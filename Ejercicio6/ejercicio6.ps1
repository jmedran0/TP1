######################################################
# Script: 	 	Ejer6.ps1
# TP:     	 	1
# Ejercicio: 	6
# Integrantes:	
#
#   Gomez Gonzalez Lucas    33.192.211
#   Medrano Jonatan         33.557.962
#   Morganella Julian       35.538.469
#   Ariel                   XXXXXXXXXX
#   Bruno                   XXXXXXXXXX
#   
# ENTREGA
######################################################

<#
.SYNOPSIS 
El siguiente script muestra ciertos datos de la computadora

.DESCRIPTION
Los datos que se muestran son: 
-Modelo de CPU
-Cantidad de Memoria RAM
-Placa de red
-Version del Sistema Operativo


(No requiere parametros)

.EXAMPLE
.\Ejer6.ps1

#>


#Se obtiene el Modelo del CPU.
$procesador= Get-WmiObject -class   win32_processor | Select-Object -Property Name

#Se obtiene la memoria RAM total y se la convierte a Gb.
$memoria = Get-WmiObject -Class Win32_ComputerSystem 
$memoria= ($memoria.TotalPhysicalMemory/1GB).ToString("#.##")

#Se obtienen la lista de las placas de red.
$PlacasRed = Get-WmiObject -Class Win32_NetworkAdapter| Select-Object -Property Name

#Se obtienen el nombre del SO, version del Service Pack y version del SO.
$NameSO = Get-WmiObject -Class Win32_operatingSystem | Select-Object -Property Caption
$ServicePackSO = Get-WmiObject -Class Win32_operatingSystem | Select-Object -Property CSDVersion
$VersionSO = Get-WmiObject -Class Win32_operatingSystem | Select-Object -Property Version
 
#Se listan los datos obtenidos.
Write-Host "Modelo CPU         : " $procesador.Name
Write-Host "Memoria RAM        : " $memoria "GB"
Write-Host "Sistema Operativo  : " $NameSO.Caption
Write-Host "CSDVersion         : " $ServicePackSO.CSDVersion
Write-Host "Version            : " $VersionSO.Version
$PlacasRed | Format-Table -AutoSize  @{Label="Placas de Red"; Expression={($_.Name)}}