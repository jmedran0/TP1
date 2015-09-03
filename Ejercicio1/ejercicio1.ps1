######################################################
# Script: 	 	ejer2.ps1
# TP:     	 	1
# Ejercicio: 	2
# Integrantes:	
#   Morganella Julian    35.538.469
#   Medrano Jonatan      33.557.962
#    
#   
# PRIMER REENTREGA
######################################################

<#
.SYNOPSIS 
Este script realiza un archivo .txt listando todos los ID y nombre de los procesos activos por la CPU. 

.DESCRIPTION
Este script realiza un archivo .txt listando todos los ID y nombre de los procesos activos por la CPU. Además, Segun $cantidad  pasada en el segundo parametro con "-cantidad n", muestra por pantalla los primeros n procesos. Por default son los primeros 3.

    
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

##--------------------------------------------------##
##--------------------------------------------------##

#EL ORIGINAL COMENTADO.
<#
Param
(
[Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
[int] $cantidad = 3
)
$existe = Test-Path $pathsalida   #si existe el path, entra al if.. sino da un mensaje de error.
if ($existe -eq $true)
{
$listaproceso = Get-Process       #pide todos los procesos
foreach ($proceso in $listaproceso)  #setea en $proceso, un objeto del registro
{
$proceso | Format-List -Property Id,Name >> procesos.txt   #hace una lista en formato .txt con los procesos, ID y Nombre del proceso.
}
for ($i = 0; $i -lt $cantidad ; $i++)
{
Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id     #Segun la cantidad pasada en el segundo parametro, muestra por pantalla los primeros procesos(default=los primeros 3)
}
}
else
{
Write-Host "El path no existe"
}
#>

<#
Respuestas
a) El objetivo de este proceso es crear un archivo de texto con la lista de todos los procesos con la propiedad ID y Nombre.
    Además, Segun $cantidad  pasada en el segundo parametro con "-cantidad n", muestra por pantalla los primeros n procesos. Por default son los primeros 3.

b)Los cambios que le haria son los siguientes:
    Agregar ayuda.
    Que no sea necesario poner la palabra "-cantidad"
    Que se cree un archivo cada vez que yo ejecuto el script.
    Y la validacion del parametro cantidad que sea mayor o igual que cero y menor a la cantidad total de parametros
#>
Param
(
[Parameter(Position = 0, Mandatory = $false)]
[String] $pathsalida = ".",
[Parameter(Position = 1, Mandatory = $false)]      #ya no es necesario que le ingrese "-cantidad" para la ejecucion.
[int] $cantidad = 3
)

$existe = Test-Path $pathsalida   #si no existe el path, da un mensaje de error...Sino, entra al if.
if ($existe -ne $true)
{
    Write-Host "El path no existe"
}
else
{

    $existe = Test-Path $pathsalida/procesos.txt

    
    #crea un archivo nuevo cada vez que se ejecuta el script, sin borrar peticiones anteriores. 
    while($existe -eq $true)  
    {
        $num++
        $existe = Test-Path $pathsalida/procesos$num.txt

    }
    $pathsalida2="$pathsalida/procesos$num.txt"



    $listaproceso = Get-Process

#Agregariamos la validacion del parametro $cantidad, que el mismo sea mayor o igual a cero y 
#menor a la cantidad total de procesos activos en la CPU. El codigo seria el siguiente:

      if($cantidad -lt 0 -or $cantidad -gt $listaproceso.Length)
  {
    Write-Output "La cantidad de procesos ingresada es incorrecta"
    exit
  }


    foreach ($proceso in $listaproceso)  
    {
    $proceso | Format-List -Property Id,Name >> $pathsalida2   
    }
    for ($i = 0; $i -lt $cantidad ; $i++)
    {
    Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id     
    }
}