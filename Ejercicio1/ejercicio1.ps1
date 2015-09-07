#**************************************************************************************************
# Nombre Del Script:		ejercicio1.ps1
# Trabajo Práctico Nro.:	1
# Ejercicio Nro.:			1
# Entrega Nro:				ENTREGA
# Integrantes:
#
#	APELLIDOS		NOMBRES			DNI
#   ------------------------------------------
#	@integrante1
#	@integrante2
#	@integrante3
#	@integrante4
#
#**************************************************************************************************

<#
    .SYNOPSIS
        Este script realiza un archivo .txt listando todos los ID y nombre de los procesos activos por la CPU.

    .DESCRIPTION
        Este script realiza un archivo .txt listando todos los ID y nombre de los procesos activos por la CPU.
        Además, Segun $cantidad  pasada en el segundo parametro con "-cantidad n", muestra por pantalla los
        primeros n procesos. Por default son los primeros 3.

    .PARAMETER path
        Path del directorio salida (default=directorio actual)

    .PARAMETER cantidad
        Cantidad de procesos mostrados por pantalla (default=3) 

    .EXAMPLE
        .\Ejer1-TP1.ps1
        .\Ejer1-TP1.ps1 -cantidad 5
        .\Ejer1-TP1.ps1 ./hola 0
        .\Ejer1-TP1.ps1 ./ 6
#>

#**************************************************************************************************
# EL CODIGO ORIGINAL COMENTADO.
#**************************************************************************************************

<#
Param
(
    [Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
    [int] $cantidad = 3
)

# si existe el path?
$existe = Test-Path $pathsalida
if ($existe -eq $true)
{
    # Si, pide todos los procesos.
    $listaproceso = Get-Process

    # Setea en $proceso, un objeto del registro.
    foreach ($proceso in $listaproceso) 
    {
        # Hace una lista en formato .txt con los procesos, ID y Nombre del proceso.
        $proceso | Format-List -Property Id,Name >> procesos.txt 
    }

    for ($i = 0; $i -lt $cantidad ; $i++)
    {
        # Segun la cantidad pasada en el segundo parametro, muestra por pantalla
        # los primeros procesos(default=los primeros 3).
        Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
    }
}
else
{
    # No, da un mensaje de error al usuario.
    Write-Host "El path no existe"
}
#>

<#
Respuestas:

a) El objetivo de este proceso es crear un archivo de texto con la lista de todos los procesos con la propiedad ID y Nombre.
    Además, Segun $cantidad  pasada en el segundo parametro con "-cantidad n", muestra por pantalla los primeros n procesos. Por default son los primeros 3.

b) Los cambios que le haria son los siguientes:
    - Agregar ayuda.
    - Que no sea necesario poner la palabra "-cantidad"
    - Agregariamos el uso del path ingresado por el usuario ya que no se usaba para nada, tiene sentido validar su existencia.
    - Agregariamos que se valide el tipo de path en cada caso para diferenciar si hablamos de un archivo o una carpeta.
    - Que se cree un archivo cada vez que yo ejecuto el script.
    - La validacion del parametro cantidad que sea mayor o igual que cero. 
    - La validacion del parametro cantidad que sea menor a la cantidad de procesos existentes, si es mayor solo mostramos la cantidad maxima de procesos.
#>

#**************************************************************************************************
# NUESTRAS MODIFICACIONES AL CODIGO ORIGINAL.
#**************************************************************************************************

Param
(
    [Parameter(Position = 0, Mandatory = $false)]
    [String] $pathsalida = ".",
    
    #ya no es necesario que le ingrese "-cantidad" para la ejecucion.
    [Parameter(Position = 1, Mandatory = $false)]
    [int] $cantidad = 3
)

# Si no existe el path, da un mensaje de error...Sino, entra al if.
$existe = Test-Path $pathsalida -PathType Container
if ($existe -ne $true)
{
    Write-Host "El path no existe"
    exit
}

# Verificamos si existe el archivo de salida.
$existe = Test-Path $pathsalida\procesos.txt -PathType Leaf

# Crea un archivo nuevo cada vez que se ejecuta el script, sin borrar peticiones anteriores.
while($existe -eq $true)  
{
    $num++
    $existe = Test-Path $pathsalida\procesos$num.txt -PathType Leaf
}

# Armamos la ruta del archivo de salida.
$pathsalida2="$pathsalida\procesos$num.txt"

$listaproceso = Get-Process

# Agregariamos la validacion del parametro $cantidad, que el mismo sea mayor o igual a cero.
if($cantidad -lt 0)
{
    Write-Output "La cantidad de procesos ingresada no puede ser negativa!"
    exit
}

# Nos aseguramos de mostrar a como maximo la cantidad de procesos existentes y no mas de eso.
$cant = [Math]::Min($cantidad, $listaproceso.count)

foreach ($proceso in $listaproceso)
{
    $proceso | Format-List -Property Id,Name >> $pathsalida2
}

for ($i = 0; $i -lt $cant; $i++)
{
    Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
}

#EOF