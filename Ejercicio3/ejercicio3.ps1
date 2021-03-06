﻿#**************************************************************************************************
# Nombre Del Script:		ejercicio3.ps1
# Trabajo Práctico Nro.:	1
# Ejercicio Nro.:			3
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
      Lee el contenido del archivo de texto [-archivo] con el en formato:
        campo1=valor1
        campo2=valor2
        campo3=valor3
        ***
        campo1=valor4
        campo2=valor5
        campo3=valor6

      y lo exporta a un archivo CSV en el directorio [-directorioDeSalida] proporcionado.
       
    .EXAMPLE
     .\ejercicio3.ps1 .\backup.txt .\

     Este comando exporta el contenido de backup.txt al archivo backup.csv en el directorio actual.
#>

Param (
    # Ambos parametros son rutas, por lo que validamos el largo apropiado segun la plataforma .NET
    [ValidateLength(1, 260)][Parameter(Position = 1, Mandatory = $true)][String]$archivo,
    [ValidateLength(1, 260)][Parameter(Position = 2, Mandatory = $true)][String]$directorioDeSalida
)

# Validamos la existencia del archivo de origen.
$existeArchivo = Test-Path -path $archivo -PathType Leaf
if ($existeArchivo -eq $true) {

    # Construimos la ruta completa del archivo de salida
    # 1 - Nos quedamos con el nombre del archivo de origen.
    # 2 - Unimos el nombre al path destino seleccionado
    # 3 - Reemplazamos la extensión.  
    $NombreDeArchivoDeEntrada = Split-Path $archivo -Leaf
    $archivoDeSalida = Join-Path $directorioDeSalida $NombreDeArchivoDeEntrada
    $archivoDeSalida = $archivoDeSalida -replace ".txt", ".csv"          

    # Validamos la existencia del archivo de origen.
    $existeDirectorioDeSalida = Test-Path -path $directorioDeSalida -PathType Container

    if ($existeDirectorioDeSalida -eq $true) {

        # Si el archivo existe, preguntamos si debemos reemplazar.
        if (Test-Path -Path $archivoDeSalida -PathType Leaf) {

            # Preguntamos hasta que se ingrese una opción correcta.            
            do {
                Write-Warning "El archivo destino ya existe. La exportación lo reemplazará."
                $opcion = Read-Host "Desea Continuar? S/N"
                $opcion = $opcion.ToUpper()

                switch ($opcion) {

                   'S' {
                        # Borramos y seguimos adelante.
                        rm -Path $archivoDeSalida -Force
                    }
                   'N' {
                        # Abortamos el proceso.
                        Write-Host "Exportación cancelada por el usuario."
                        exit
                    }
                }

            } While ($opcion -ne 'S' -and $opcion -ne 'N')
        }

        # Creamos el hash table para almacenar los pares key=Value
        [HasTable] $htRegistro = @{}        

        # Leemos el contenido dividiendo el contenido por el record separator de la la consigna.
        $registros = Get-Content $archivo -Delimiter "***"

        # Se nos devuelve un solo objeto string por cada separacion, que contiene todos los campos separados por \n.
        foreach($registro in $registros) {

            # Limpiamos el hash.
            $htRegistro.Clear()

            # Separamos los campos.
            $campos = $registro.Split("`n")

            # Agregamos cada campo al registro que va a ser exportado
            foreach($campo in $campos) {    

                # Separo el par mediante el '='
                $nombreCampo, $valor = $campo.split("=")                 

                # Luego del split las variables pueden quedan en null, en ese caso salteamos el campo.
                if (($nombreCampo -eq $null) -or ($valor -eq $null)) {
                    continue
                } 

                # Quitamos los espacios. 
                $nombreCampo = $nombreCampo.trim()                    
                $valor = $valor.trim()

                # Manejamos el error frente a un campo duplicado en el archivo.
                try {
                     # Agrego el par ya separado al registro.
                     $htRegistro.add($nombreCampo, $valor)
                } catch {
                    "Error: Se detecto un campo duplicado en el registro!" 
                }                
            }

            # A partir del registro que formamos, creamos el objeto que puede ser exportado.
            $obj = New-Object -TypeName PSObject -Property $htRegistro

            # Exportamos al archivo 'backup.csv' en el directorio seleccionado.
            $obj | Export-Csv -Path ($archivoDeSalida) -NoTypeInformation -Force -Append
        }

    } else {
        Write-Error ("**** El directorio `"$directorioDeSalida`" no existe no existe. *****")
    }
} else {
    Write-Error ("**** El archivo `"$archivo`" no existe. *****")
}

#EOF