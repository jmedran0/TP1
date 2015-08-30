# Nombre Del Script: 
# Trabajo Práctico Nro.: 
# Ejercicio Nro.: 
# Entrega: 
# Integrantes: APELLIDOS, nombres, DNI
#    @integrante1
#    @integrante2
# Descripción:

<#  
    .SYNOPSIS 
      Copia los archivos de la ruta [-origen] que contienen el texto especificado
      en [-cadena] al direcorio destino especificado en [-destino] 
       
    .EXAMPLE
     .\ejercicio2.ps1 "Texto a buscar" -origen .\Pepe -destino .\Pepito
#>

Param(
    [Parameter(Position = 1, Mandatory = $true)]
    [ValidateNotNullOrEmpty()][String]$cadena,

    [Parameter(Position = 2, Mandatory = $true)]
    [ValidateLength(1, 260)][String]$origen,
    
    [Parameter(Position = 3, Mandatory = $true)]
    [ValidateLength(1, 260)][String]$destino = ".\"
)

# Validamos la existencia del directorio origen.
$existeOrigen = Test-Path -Path $origen -PathType container

if ($existeOrigen -eq $true) {
    
    # TODO: chequear permisos sobre destino.
     
    # Definimos el nombre del archivo de logs.
    $archivoDeLogs = $Origen + '\logs.txt'

    # Get-ChildItem: Obtenemos los archivos de origen de forma recursiva,
    # Select-String: Seleccionamos solo aquellos que contengan la cadena buscada,
    # Resolve-Path: Nos aseguramos de quedarnos con el path completo de cada objeto devuelto, sin la informacion adicional.
    $listaDeArchivos = (Get-ChildItem -Path $origen -Recurse | Select-String -pattern $cadena -list | Resolve-Path)

    # Para cada archivo..
    foreach ($archivo in $listaDeArchivos) {
      
       # Split-Path: obtenemos la carpeta de padre del archivo de origen.
       $ubicacionDelArchivoEnOrigen = Split-Path $archivo -Parent                   
       
       # Obtenemos el path absoluto del origen. De '.\origen' obtengo 'C:\Users\Pepe\Origen'
       $origenAbsoluto = Resolve-Path $origen

       # Para usar la ruta en el replace, reemplazamos la barra simple por una doble y nos queda 'C:\\Users\\Pepe\\Origen' 
       $pattern = $origenAbsoluto -replace "\\",'\\'

       # Reemplazamos la raiz de la ruta origen por la ruta destino, u obtenemos la ubicacion en el destino.
       $ubicacionDelArchivoEnDestino = $ubicacionDelArchivoEnOrigen -replace $pattern, $destino 

       # Intentamos crear la ruta de destino para el archivo que vamos a copiar.
       mkdir $ubicacionDelArchivoEnDestino -Force *> $null
        
       # Ahora copiamos el archivo en la punta de la rama creada.
       Copy-Item $archivo -Destination $ubicacionDelArchivoEnDestino -Force

       # TODO: Generar logs. 
       <#
       $log = ($Archivo | Get-Item | Format-Table -autosize -HideTableHeaders -Property LastWriteTime, Length, Name)

       $log = $ubicacionDelArchivoEnOrigen + $log

       $log | Out-File $archivoDeLogs -Append
       #>
    }
    
} else {
    Write-Error "El directorio de origen no existe".
}

