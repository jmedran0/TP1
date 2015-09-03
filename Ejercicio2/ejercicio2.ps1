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
Este script copia a un directorio todos los archivos de texto que contengan una cadena determinada. 

.DESCRIPTION
Este script realiza un script que copia a un directorio todos los archivos de texto que contengan una cadena determinada. Debe recibir por parámetro la cadena a buscar, el directorio de origen y el de destino.
Además, genera un archivo log.txt dentro de la carpeta destino, mostrando una tabla con directorio de origen, tamaño y fecha de modificacion. 
    
.PARAMETER cadena
Palabra o nombre del archivo a buscar.

.PARAMETER pathorigen
Path del directorio origen.

.PARAMETER pathdestino
Path del directorio salida.

.EXAMPLE
.\Ejer2-TP1.ps1 "PowerShell" c:\ ./carpetadestino
.\Ejer2-TP1.ps1 procesos ./carpetaorigen ./carpetadestino
.\Ejer2-TP1.ps1 
                     
#>

Param(  [Parameter(Mandatory=$true,position=0)] 
        [ValidateNotNullOrEmpty()]
        [string]$cadena,

        [Parameter(Mandatory=$true,position=1)] 
        [ValidateNotNullOrEmpty()]
        [string]$path_origen,

        [Parameter(Mandatory=$true,position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$path_destino
    )

        #valido cantidad de parametros // Aunque ya esta validado anteriormente con el "Mandatory=$true"
if($PSBoundParameters.Count -ne 3)
{
    Write-Host "La cantidad de parametros ingresada es incorrecta"
	exit
}

#Valido que el path sea correcto
$valido_path=Test-Path -Path "$path_origen"

#Valido que el path_origen sea correcto
if( $valido_path -eq $true )
{
$path_origen=Resolve-Path -Path $path_origen
}
else{
    Write-Host "El path de Origen ingresado es incorrecto."
	exit
}


#Valido que el path sea correcto
$valido_ruta=Test-Path -Path "$path_destino"

#Valido que el path_destino sea correcto
if( $valido_ruta -eq $true )
{
$path_destino=Resolve-Path -Path $path_destino  #Convierto el path a absoluto.
}
else{
    Write-Host "El path de destino ingresado es incorrecto."
	exit
}

    $existe = Test-Path $path_destino/log.txt
    
    #crea un archivo de log nuevo cada vez que se ejecuta el script, sin borrar peticiones anteriores. 
    while($existe -eq $true)  
    {
        $num++
        $existe = Test-Path $path_destino/log$num.txt

    }
    $pathlog="$path_destino/log$num.txt"

   

#En forma recursiva el directorio "path_origen" 
$objeto_arch = Get-ChildItem -Path "$path_origen" -File -Recurse | Where-Object Name -CMatch "$cadena"         #Busco todos los archivos que esten dentro de $path_origen, y selecciono solo los que el nombre contengan a $cadena, discrimina mayusculas y minusculas por eso uso el Cmatch.

foreach($archivo in $objeto_arch){
        #Copia de los archivos en la carpeta de destino
        Copy-Item -LiteralPath $archivo.FullName -Destination "$path_destino" -Force
}


  #Creo un log en formato de tabla, segun los datos de los archivos copiados.
    $objeto_arch|Format-Table -AutoSize  @{Label="Path"; Expression={($_.FullName)}},@{Label='Tamaño[Byte]'; Expression={($_.Length)}}, @{Label="Ultima Modificación"; Expression={($_.LastWriteTime)}} | Out-File -FilePath $pathlog