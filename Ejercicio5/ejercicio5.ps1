#**************************************************************************************************
# Nombre Del Script:		ejercicio5.ps1
# Trabajo Práctico Nro.:	1
# Ejercicio Nro.:			5
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
Este script realiza un backup comprimiendo los archivos de un directorio.

.DESCRIPTION
El script se encarga de comprimir los archivos del directorio informado en el primer parametro y
los guarda en el directorio destino informado en el segundo parametro.
En caso de que el path de destino contenga mas de 3 archivos, se eliminará el mas antiguo.
    
.PARAMETER pathOrigen
Path del directorio que contiene los archivos que se van a comprimir

.PARAMETER pathDestino
Path del el directorio en donde se guardara el backup.

.EXAMPLE
ejer5.ps1 C:\Users\Archivos C:\Users\Backups
                     
#>


Param(
      [Parameter(Mandatory=$true)]
      [string]$pathOrigen,
      [Parameter(Mandatory=$true)]
      [string]$pathDestino
       )



#Valido cantidad de parametros
if($PSBoundParameters.Count -ne 2)
{
	Write-Output "
	Error. La cantidad de parametros ingresada es incorrecta."
	exit
}	

#Valido que los path de Origen y Destino sean correctos.
$test_origen = Test-Path -Path $pathOrigen
$test_destino=Test-Path -Path "$pathDestino"

#cambio de path relativo a absoluto
if( $test_origen -eq $true )
{
    Push-Location -Path $pathOrigen 
    $pathOrig=$PWD
    Pop-Location
}
else
{
    write-Output "La Ruta de acceso del parametro $pathOrigen es incorrecta."
    exit
}
#cambio de path relativo a absoluto
if( $test_destino -eq $true )
{
    Push-Location -Path $pathDestino 
    $pathDest=$PWD
    Pop-Location
}
else
{
    write-Output "La Ruta de acceso del parametro $pathDestino es incorrecta."
    exit
}


#Guardo la fecha del backup en formato YYYYMMDD
$fecha=$(Get-Date -UFormat "%Y%m%d")

#Asocio la dll de .NET a PowerShell
Add-Type -AssemblyName "System.IO.Compression.FileSystem"

try 
    {

        #Verifico si se vuelve a hacer un backup el mismo dia
        if(test-Path $pathDest/$fecha.zip)
        {
	        Write-Output "El archivo ya existe con ese nombre. Se va a sobreescribir."
	        $archAborrar = "$pathDest" + '\' + $fecha + '.zip'
	        Remove-Item $archAborrar
        }
        #Se comprime el directorio origen y se guarda en el directorio destino.
        [System.IO.Compression.ZipFile]::CreateFromDirectory("$pathOrig","$pathDest" + '\' + $fecha + '.zip')
    
   }
catch
   {
    Write-Output "Se produjo un error en la creacion del archivo zip."
    exit
    }

write-Output "###########################################################"
Write-Output "Se creo satifactoriamente el archivo zip $fecha.zip"
write-Output "###########################################################"

#Valido si la carpeta destino tiene mas de 3 archivos, caso afirmativo se borran los mas antiguos.
$cantArchivos=(Get-ChildItem $pathDest -Name -Filter *.zip).count
if($cantArchivos -gt 3)
{
    $cantABorrar = $cantArchivos - 3
    $archivosABorrar = Get-ChildItem $pathDest -Name -Filter *.zip | Sort-Object -Property CreationTime | Select-Object -First $cantABorrar
	Write-Output "La carpeta destino contiene mas de 3 archivos .zip, se procedera a borrar los archivos mas antiguos."   
    foreach ($file in $archivosABorrar)
	{
		$pathCompleto = "$pathDest" + '\' + $file
		Write-Output "Borrando: $pathCompleto"
		Remove-Item $pathCompleto
	}
}

#EOF