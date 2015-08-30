# Trabajo Práctico Número 1

## Tema

Programación de scripts básicos en PowerShell.

## Descripción

Se programarán todos los scripts mencionados en el presente trabajo, teniendo especialmente en cuenta las recomendaciones sobre programación mencionadas en la introducción de este trabajo. Los contenidos de este trabajo práctico pueden ser incluidos como tema de parciales.

## Formato de entrega

Electrónico e impreso en el Laboratorio 266 siguiendo el protocolo especificado anteriormente.

## Documentación

Todos los scripts que se entreguen deben tener un encabezado y un fin de archivo. Dentro del encabezado deben figurar el nombre del script, el trabajo práctico al que pertenece y el número de ejercicio dentro del trabajo práctico al que corresponde, el nombre de cada uno de los integrantes detallando nombre y apellido y el número de DNI de cada uno (tenga en cuenta que para pasar la nota final del trabajo práctico será usada dicha información, y no se le asignará la nota a ningún alumno que no figure en todos los archivos con todos sus datos), también deberá indicar el número de entrega a la que corresponde (entrega, primera reentrega, segunda reentrega, etc.). Para su mejor comprensión del tema vea el ejercicio 4 de la primera entrega que fue diseñado para que su trabajo sea más fácil.

## Evaluación

Luego de entregado el trabajo práctico los ayudantes procederán a evaluar los ejercicios resueltos, en caso de encontrar errores se documentará en la carátula del TP que será devuelta al grupo con la evaluación final del TP y una fecha de reentrega en caso de ser necesaria (en caso de no cumplir con dicha fecha de reentrega el trabajo práctico será desaprobado). Cada ayudante podrá determinar si un determinado grupo debe o no rendir coloquio sobre el trabajo práctico presentado.

Las notas sobre los trabajos también estarán disponibles en el [sitio de la cátedra](www.sisop.com.ar) donde además del estado de la corrección se podrá ver un detalle de las pruebas realizadas y los defectos encontrados.

**Importante:** Cada ejercicio cuenta con una lista de validaciones mínimas que se realizará, esto no implica que se puedan hacer otras validaciones al momento de evaluar el trabajo presentado

## Fecha de entrega

No se aceptará una entrega posterior sin tener entregadas todas las anteriores.

* **Fecha de entrega**: Del 07/09/2015 al 11/09/2015, dependiendo del día que se curse la materia y sólo en la primer fecha en que se cursa (Lunes/Martes/Viernes).
* **Fecha tardía de entrega**: Del 14/09/2015 al 18/09/2015, dependiendo del día que se curse la materia y sólo en la primer fecha en que se cursa (Lunes/Martes/Viernes).

## Introducción

La finalidad del presente práctico es que los alumnos adquieran un cierto entrenamiento sobre la programación de shell scripts en lenguaje PowerShell, practicando el uso de utilitarios comunes provistos por los sistemas operativos Windows. Todos los scripts, están orientados a la administración de una máquina, o red y pueden ser interrelacionados de tal manera de darles una funcionalidad real.
Cabe destacar que todos los scripts deben poder ser ejecutados en forma batch o interactiva, y que en ningún caso serán probados con el usuario Administrador, por lo cual deben tener en cuenta al realizarlos, no intentar utilizar comandos, directorios, u otros recursos que solo están disponibles para dicho usuario, o usuarios del grupo. Todos los scripts deberán funcionar en las instalaciones del laboratorio 266, ya que es ahí donde serán controlados por el grupo docente.
Para un correcto y uniforme funcionamiento, todos ellos deberán respetar algunos lineamientos generales:

* **Modularidad**: Si bien es algo subjetivo del programador, se trata de privilegiar la utilización de funciones (internas/externas), para lograr una integración posterior menos trabajosa.
* **Claridad**: Se recomienda fuertemente el uso de comentarios que permitan la máxima legibilidad posible de los scripts.
* **Verificación**: Todos los scripts deben realizar un control de las opciones que se le indiquen por línea de comando, es decir, verificar la sintaxis de la misma. En caso de error u omisión de opciones, al estilo de la mayoría de los comandos deben indicar mensajes como: `"Error en llamada! Uso: comando [...]"`. Donde se indicará entre corchetes `[...]`, los parámetros opcionales; y sin ellos los obligatorios, dando una breve explicación de cada uno de ellos. Todos los scripts deben incluir una opción estándar `-?` que indique el número de versión y las formas de llamada.

## Ejercicios

Los ejercicios que se encuentran dentro de esta sección son básicos, y fueron diseñados para que los alumnos adquieran un primer contacto con los comandos de Windows, y con la forma de programar scripts con las herramientas específicas del sistema operativo.

### Ejercicio 1

En base al siguiente script de PowerShell se pide que lo ejecute y analice, y en base a los resultados responda las preguntas que figuran más abajo.

**Importante:** como  parte del resultado se deberá entregar el script en un archivo tipo `ps1` y las respuestas en el mismo código.

```posh
Param
(
    [Parameter(Position = 1, Mandatory = $False)][String] $pathSalida = ".",
    [Int] $cantidad = 3
)

$existe = Test-Path $pathSalida
if($existe -eq $True)
{
    $listProcesos = Get-Process
    foreach ($proceso in $listProcesos)
    {
        $proceso | Format-List -Property Id,Name >> procesos.txt
    }
    for ($i = 0; $i -lt $cantidad; $i++)
    {
        Write-Host $listProcesos[$i].Name - $listProcesos[$i].Id
    }
}
else
{
    Write-Host "El path no existe"
}
```

1. ¿Cuál es el objetivo del script?.
2. ¿Agregaría alguna otra validación a los parámetros? ¿Cuál/es? (detallar el código de las validaciones que incorporaría).

### Ejercicio 2

Realizar un script que copie a un directorio todos los archivos de texto que contengan una cadena determinada. Debe recibir por parámetro la cadena a buscar, el directorio de origen y el de destino.

Al finalizar la copia, se debe crear un archivo de log en donde se indique el directorio de origen, el tamaño y la fecha de modificación de cada uno de los archivos copiados.

#### Criterios de corrección

| Control                                            | Criticidad   |
| -------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                     | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`. | Obligatorio. |
| Validación correcta de parámetros.                 | Obligatorio. |
| Búsqueda recursiva en el directorio de origen.     | Obligatorio. |

### Ejercicio 3

Un sistema realiza un backup de su base de datos en un archivo de texto plano con el siguiente formato:

```
Campo1=Valor1
Campo2=Valor2
Campo3=Valor3
***
Campo1=Valor4
Campo2=Valor5
Campo3=Valor6
```

Cada línea contiene el valor de un campo para un registro. Cada registro se encuentra separado del otro por 3 asteriscos.

Se necesita crear un script que lea el archivo de backup y genere un archivo CSV para poder procesarlo más fácilmente. La primer fila del archivo CSV debe contener los nombres de los campos, y en las filas siguientes estarán los valores de los mismos.

#### Criterios de corrección

| Control                                                                               | Criticidad   |
| ------------------------------------------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                                                        | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`.                                    | Obligatorio. |
| Validación correcta de parámetros.                                                    | Obligatorio. |
| Se debe usar el *cmdlet* `Export-CSV`.                                                | Obligatorio. |
| El archivo de origen y la ruta del archivo de salida deber ser pasadas por parámetro. | Obligatorio. |

### Ejercicio 4

Realizar un script que cuenta la cantidad de ocurrencias de una palabra. La entrada del script puede ser un archivo de texto o a través de la redirección estándar usando “|”. La salida se debe mostrar en formato de tabla usando `Format-Table`.

#### Criterios de corrección

| Control                                            | Criticidad   |
| -------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                     | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`. | Obligatorio. |
| Validación correcta de parámetros.                 | Obligatorio. |
| Se deben usar arrays asociativos.                  | Obligatorio. |

### Ejercicio 5

Una empresa tiene un sistema web al que los usuarios pueden subir archivos. Todas las noches, una persona se encarga de hacer un backup de esos archivos de forma manual. Se desea automatizar dicha tarea utilizando un script Powershell.

Los requisitos son los siguientes:

* Se debe recibir por parámetro el directorio que contiene los archivos subidos por los usuarios.
* Se debe recibir por parámetro el directorio en donde se guardará el backup.
* El backup debe estar comprimido en formato ZIP.
* El nombre del backup tiene que ser la fecha del backup con el siguiente formato `YYYYMMDD.zip`.
* Si hay más de 3 archivos `.zip` en el directorio del backup se debe borrar el más viejo.

#### Criterios de corrección

| Control                                                                                                 | Criticidad   |
| ------------------------------------------------------------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                                                                          | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`. Debe incluir ejemplos.                               | Obligatorio. |
| Validación correcta de tipo y cantidad de parámetros.                                                   | Obligatorio. |
| Se usa la clase `ZipFile` de .NET para resolver la compresión de archivos. Ver comando `Add-Component`. | Obligatorio. |

### Ejercicio 6

Se requiere hacer un script que muestre los siguientes datos de la computadora en donde se lo corre: modelo de CPU, cantidad de memoria RAM, placas de red y versión del sistema operativo.

#### Criterios de corrección

| Control                                            | Criticidad   |
| -------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                     | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`. | Obligatorio. |
| Validación correcta de parámetros.                 | Obligatorio. |
| Se debe usar el *cmdlet* `Get-WmiObject`.          | Obligatorio. |

### Ejercicio 7

Realizar un script que analice la estructura de una matriz y determine el tipo al que corresponde. La matriz a analizar será cargada desde un archivo de texto plano, en el que las columnas estarán separadas por un carácter recibido por parámetro y las filas por un salto de línea.

Los tipos de matrices a analizar serán los siguientes:

* Matriz Cuadrada.
* Matriz Rectangular.
* Matriz Fila.
* Matriz Columna.
* Matriz Identidad.
* Matriz Nula.

Cabe destacar que una matriz puede pertenecer a más de un tipo, por lo que se deberán informar todos aquellos en los que coincida. En el caso de ser una matriz cuadrada, indicar el orden de la misma.

Se debe pasar por parámetro el separador de columnas de la matriz.

#### Criterios de corrección

| Control                                                                   | Criticidad   |
| ------------------------------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                                            | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`. Debe incluir ejemplos. | Obligatorio. |
| Validación correcta de tipo y cantidad de parámetros.                     | Obligatorio. |

### Ejercicio 8 (entrega tardía)

Realizar un script que genere un log de ejecución de un proceso. Cada una *X*-cantidad de segundos, debe loguear el uso de procesador, la cantidad de threads y la cantidad de memoria que utiliza el proceso. Si el proceso se finaliza, se debe loguear la fecha de finalización del mismo.


#### Criterios de corrección

| Control                                                                      | Criticidad   |
| ---------------------------------------------------------------------------- | ------------ |
| Debe cumplir con el enunciado.                                               | Obligatorio. |
| El script debe tener ayuda visible con `Get-Help`.                           | Obligatorio. |
| Validación correcta de parámetros.                                           | Obligatorio. |
| Se debe usar el *cmdlet* `Get-WmiObject` o `Get-Counter`.                    | Obligatorio. |
| Se deben usar los eventos de los procesoso para detectar cuando termina uno. | Obligatorio. |
