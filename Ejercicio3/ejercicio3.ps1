# Nombre Del Script: 
# Trabajo Práctico Nro.: 
# Ejercicio Nro.: 
# Entrega: 
# Integrantes: APELLIDOS, nombres, DNI
#    @integrante1
#    @integrante2
# Descripción

Param (
    # Ambos parametros son rutas, por lo que validamos el largo apropiado segun la plataforma .NET
    [ValidateLength(1, 260)][Parameter(Position = 1, Mandatory = $false)][String]$archivo,
    [ValidateLength(1, 260)][Parameter(Position = 2, Mandatory = $false)][String]$directorioDeSalida
)

# Validamos la existencia del archivo de origen.
$existeArchivo = Test-Path -path $archivo -PathType Leaf
if ($existeArchivo -eq $true) {
    
    # Validamos la existencia del archivo de origen.
    $existeDirectorioDeSalida = Test-Path -path $directorioDeSalida -PathType Container
    if ($existeDirectorioDeSalida -eq $true) {
        
        # Leemos el contenido en grupos de 4 lineas, que conform
        $registros = Get-Content $archivo -ReadCount 4
        foreach($registro in $registros) {

            # Creamos el hash table para almacenar los pares key=Value
            $htRegistro = @{}
            
            # Agregamos cada campo al registro que va a ser exportado
            foreach($campo in $registro) {
            
                # Evitamos las lineas vacias y con '***' 
                if ($campo -notmatch "[*][*][*]" -and $campo -ne "") {                  
                    
                    # Separo el par mediante el '='
                    $nombreCampo, $valor = $campo -split "="             

                    # Agrego el par ya separado al registro.
                    $htRegistro.Add($nombreCampo, $valor)                          
                }
            }
            
            # Creamos el objeto que puede ser exportado a partir del registro que formamos.
            $obj = New-Object -TypeName PSObject -Property $htRegistro
            
            # Exportamos al archivo 'backu.csv' en el directorio seleccionado.
            $obj | Export-Csv -Path ($directorioDeSalida + "backup.csv") -NoTypeInformation -Force -Append
        }
       
    } else {
        Write-Error ("**** El directorio `"" + $directorioDeSalida + "`" no existe no existe. *****")
    }
} else {
    Write-Error ("**** El archivo `"" + $archivo + "`" no existe. *****")
}

