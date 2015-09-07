#**************************************************************************************************
# Nombre Del Script:		ejercicio4.ps1
# Trabajo Práctico Nro.:	1
# Ejercicio Nro.:			4
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
      Este script lee el contenido del archivo de texto [-archivo], la entrada redireccionada con "|" o el
      contenido obtenido con (Get-Content <file>) en [-contenido] 
      muestra por pantalla la cantidad de ocurrencias de cada una de las palabras que lo componen.
      
      El archivo proporcionado en la ruta debe ser un archivo nombrado "*.txt".
       
    .EXAMPLE
     .\ejercicio4.ps1 .\articulo.txt
     
     Este comando muestra la cantidad de ocurrencias de cada palabra del archivo en formato tabla.

    .EXAMPLE
     Get-Content .\articulo.txt | .\ejercicio4.ps1

     Este comando muestra la cantidad de ocurrencias de cada palabra en el contenido redireccionado en el pipeline.
     Util en el caso de contar con un archivo de text plano que no es un "*.txt".
#>

# Extendemos la funcionalidad del script, para aceptar objetos a travez de la redireccion estandar.
[CmdletBinding()]

Param(
    # Validamos el largo de la ruta al archivo para cumplir con la convencion de la API de windows
    # Fuente: https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247(v=vs.85).aspx#naming_conventions
    # Ver: "Maximum Path Length Limitation"
    [ValidateLength(0, 260)][Parameter(Position = 1, Mandatory = $false)][String]$archivo,
    
    # Esperamos objetos desde el pipeline.
    [ValidateNotNullOrEmpty()][Parameter(DontShow, ValueFromPipeline = $true, Mandatory = $false)]$contenido
)

# Bloque de inicializacion necesario para que PS no confunda el bloqe Process
# con el Cmdlet Get-Process y falle por no encontrar el parametro -Name 
# Fuente: http://learn-powershell.net/2013/05/07/tips-on-implementing-pipeline-support/
# Ver: "Do I need all of these Begin, Process and End blocks?" y "The way to do it…"
Begin {
    
    # Nos fijamos si nos estan dando la ruta del archivo.
    if ($PSBoundParameters.ContainsKey("archivo")) {
       
        # Validamos que el archivo exista. 
        $existeArchivo = Test-Path $archivo -PathType Leaf
        if ($existeArchivo -eq $true) {
        
            # Debido a que windows infiere el tipo de archivo basado en la extension,
            # nos permitimos validalo de esta manera.
            $esTxt = $archivo.EndsWith(".txt")
            if ($esTxt -eq $true) {
                $contenido = Get-content $archivo
            } else {
                Write-Host "El archivo `"$archivo`" no es un archivo de texto."
                exit
            }

        } else {
            Write-Host "El archivo `"$archivo`" no existe."
            exit
        }        
    }

    # Creamos el array asociativo
    [hashtable] $contador = @{}
}

# La entrada viene dada de a una linea por vez, debemos iterarla.
Process {

    # Procesamos.

    # Separamos las palabras por cualquiera de los caracteres indicados. Si no hay texto 
    # entre dos caracteres delimitadores, la palabra puede quedar vacia. La opcionde split
    # RemoveEmptyEntries las elimina del resultado
    $words = $contenido.Split(" ,.;:?(){}[]\/|@<>!#$%^&*_+-=~`"`n'´", [System.StringSplitOptions]::RemoveEmptyEntries)
    
    foreach($word in $words) {

        $contador[$word] += 1
    }
}

End {
    # Mostramos las cantidades en formato tabla y customizamos los nombres de las columnas.
    $contador.GetEnumerator() | Sort-Object -Property Key | Format-Table -AutoSize -Property @{Expression={$_.Name};Label="Palabra"}, @{Expression={$_.value};Label="Cantidad"} 
}

#EOF