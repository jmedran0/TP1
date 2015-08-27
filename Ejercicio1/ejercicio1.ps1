# Nombre Del Script: 
# Trabajo Práctico Nro.: 
# Ejercicio Nro.: 
# Entrega: 
# Integrantes: APELLIDOS, nombres, DNI
#    @integrante1
#    @integrante2
# Descripción: 

Param
(
    [Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
    [int] $cantidad = 3
)

$existe = Test-Path $pathsalida
if ($existe -eq $true)
{
    $listaproceso = Get-Process

    foreach ($proceso in $listaproceso)
    {
        $proceso | Format-List -Property Id,Name >> procesos.txt
    }

    for ($i = 0; $i -lt $cantidad; $i++)
    {
        Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
    }
}
else
{
    Write-Host "El path no existe"
}