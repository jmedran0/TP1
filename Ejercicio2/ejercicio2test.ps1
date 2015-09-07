#**************************************************************************************************
# Nombre Del Script:		ejercicio2.ps1
# Trabajo Práctico Nro.:	1
# Ejercicio Nro.:			2
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

Param (  
    [Parameter(Mandatory=$true,position=0)] 
    [ValidateNotNullOrEmpty()]
    [string]$cadena,

    [Parameter(Mandatory=$true,position=1)] 
    [ValidateNotNullOrEmpty()]
    [string]$path_origen,

    [Parameter(Mandatory=$true,position=2)]
    [ValidateNotNullOrEmpty()]
    [string]$path_destino
)

# Valido cantidad de parametros, aunque ya esta validado anteriormente con el "Mandatory=$true"
if ($PSBoundParameters.Count -ne 3) {
    Write-Host "La cantidad de parametros ingresada es incorrecta."
	exit
}

# Valido que el path sea correcto
$valido_path=Test-Path -Path "$path_origen"

if ( $valido_path -ne $true ) {
    Write-Host "El path de Origen ingresado eno existe."
	exit
}

# Validamos que el path proporcionado sea sintácticamente válido.
$valido_ruta=Test-Path -Path "$path_destino" -IsValid

if ( $valido_ruta -ne $true ) {
    Write-Host "El path de destino ingresado es incorrecto."
	exit
}

# Nos aseguramos de trabajar con los paths absolutos.
$path_origen=Resolve-Path -Path $path_origen

# Manejamos el archivo de logs. Un log nuevo por cada ejecusión.
$existe = Test-Path $path_origen\log.txt -PathType Leaf

while ($existe -eq $true) {
    $num++
    $existe = Test-Path $path_origen\log$num.txt
}

$pathlog="$path_origen\log$num.txt"

# En forma recursiva el directorio "path_origen". Busco todos los archivos que esten dentro de $path_origen,
# y selecciono solo los que contengan a $cadena, discriminando mayusculas y minusculas.
$objeto_arch = (Get-ChildItem -Path "$path_origen" -File -Recurse | Select-String "$cadena" -List | Resolve-Path)

foreach ($archivo in $archivos) {
    # Armamos el patron para usar en el replace.
    $pattern = $path_origen -replace "\\", "\\"

    # cambia la ruta de carpeta origen por destino de los archivos encontrados.
    $archivodestino = $archivo -replace $pattern, $path_destino
    
    # Me va a decir cual seria la ruta del archivo a crear(sin el nombre del archivo). crea el padre del directorio de destino
    $path_d = Split-Path $archivodestino -Parent
    
    try {
        # Si no existe el directorio destino se crear
        mkdir $path_d -Force *> $NULL

        # Copia de los archivos en la carpeta de destino
        Copy-Item $archivo -Destination $path_d -Force
    } catch {
        Write-Host "No se tiene acceso para crear la ruta especificada."
        continue
    }
}

# Solo logueamos y mostramos si la busqueda arroja algun resultado.
if ($objeto_arch.count -gt 0) {
    # Creo un log en formato de tabla, segun los datos de los archivos copiados.
    $objeto_arch | Format-Table -AutoSize  @{Label="Path"; Expression={($_.FullName)}},@{Label='Tamaño[Byte]'; Expression={($_.Length)}}, @{Label="Ultima Modificación"; Expression={($_.LastWriteTime)}} | Out-File -FilePath $pathlog
}
#EOF