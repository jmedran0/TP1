# Nombre Del Script: 
# Trabajo Práctico Nro.: 
# Ejercicio Nro.: 
# Entrega: 
# Integrantes: APELLIDOS, nombres, DNI
#    @integrante1
#    @integrante2
# Descripción: Script propuesto por la catedra. Modificado con validaciones y mejoras.
# El objetivo de este script es listar los procesos en ejecusion.

Param
(
    # Validamos el length de $pathsalida para que no supere el largo permitido por windows.
    [ValidateLength(1,260)][Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".\",
    
    # fijamos $cantidad en la posicion 2 para poder ejecutar el script sin el nombre del parametro. 
    [Parameter(Position = 2, Mandatory = $false)][int] $cantidad = 3
)

# evaluo si el path proporcionado es un directorio.
$esdirectorio = Test-Path $pathsalida -IsValid -PathType Container 

if ($esdirectorio -eq $true) {

    # Ahora evaluo si existe.
    $existe = Test-Path $pathsalida

    if ($existe -eq $true) {
        # Uso el path seleccionado, haciendo que la validacion del path tenga sendtido. 
        $archivo = $pathsalida + "procesos.txt"
        
        $listaproceso = Get-Process

        foreach ($proceso in $listaproceso) {
            $proceso | Format-List -Property Id,Name >> $archivo
        }
        
        # Reasigno la cantidad solicitada, para no mostrar mas Procesos de los que hay.
        if ($cantidad -gt $listaproceso.Count) {
            $cantidad = $listaproceso.count
        }
                   
        for ($i = 0; $i -lt $cantidad; $i++) {         
            Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
        }
    } else {
        Write-Host "El directorio no existe."
    }   
} else {
    Write-Host "El path no es un directorio."
}



