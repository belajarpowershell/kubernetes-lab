# PowerShell Script 
# Script: Create-HyperVVM.ps1
# Description: Script to create Hyper-V VMs based on configurations in a CSV file
# Author: Suresh Solomon ( sureshsolomon@yahoo.com)
# Date: November 15, 2023

<#
Disclaimer:
This script is provided as-is without any warranty. Use it at your own risk.
The author and contributors are not responsible for any damages or data loss caused by the script.
Please review and understand the script before execution. Make sure to backup your data and test the script in a non-production environment.

Usage:
1. Set the execution policy to RemoteSigned before running the script.
2. Modify the CSV file (vms.csv) with your VM configurations.
3. Run the script to create Hyper-V VMs based on the provided configurations.

#>

# create working folder
# this script will default to  F:\kubernetes-project-lab
# To change this path search for 'F:\kubernetes-project-lab' replace with the path 
# There is only one location to change under # create working folder
# Change the Drive letter to on that exists on your computer,
# You will also need to  update External Network name  for $switchInternet="internet"
##  Hyper-V > Virtual Switch Manager > Identify the External Switch name

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
<#
This script will read from a file called vms.csv
Copy the content below and paste in a file vms.csv 
Feel free to edite the VM name to your preference


example content of "vms.csv"
VMName,NetworkSwitch1,NetworkSwitch2,DiskSizeGB1,DiskSizeGB2,CPUCount,MemoryGB,ISOPath,BootOrder
aaa-alpine1,Internet,"Private 192.168.100.0/24",50,,1,1,alpine-standard-3.18.4-x86_64.iso,DVD
aaa-loadbalancer,,"Private 192.168.100.0/24",50,,1,1,alpine-standard-3.18.4-x86_64.iso,DVD
aaa-master1,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-master1,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-master2,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-master3,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-worker1,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-worker2,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-worker3,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
aaa-xsinglenode,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network

##
NetworkSwitch1 : this is the internet connection . Please change internet to the name of your external Network on Hyper-V
NetworkSwitch2 : this is the private network "Private 192.168.100.0/24"
ISOPath : if there is a DVD loaded the iso name is listed here.
BootOrder : 
DVD > First Boot DVD, Second Boot HDD
Network > First Boot Network  "Private 192.168.100.0/24" , Second Boot HDD
#>

# Get the directory containing the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path


# Set the path to the CSV file
$csvPath = "$scriptDirectory\vms.csv"

# Read the CSV file
$vms = Import-Csv -Path $csvPath

# create working folder
#this is where the Hyper-V files will be created.
# this script will default to  F:\kubernetes-project-lab
$workingfolder = "F:\kubernetes-project-lab"
if (!(Test-Path -Path "$workingfolder" -PathType Container)) {
        New-Item -Path "$workingfolder" -ItemType Directory
    }
    

### Download the ISO images to the folder listed here.
$isofolder = "$workingfolder\iso\"
if (!(Test-Path -Path "$isofolder" -PathType Container)) {
        New-Item -Path "$isofolder" -ItemType Directory
    }

## Download alpine iso
$outputPath = $DVDalpine
$url = "https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-standard-3.18.4-x86_64.iso"
$DVDalpine=Join-Path $isofolder (Split-Path $url -Leaf) # extracts filename from downloadurl

# download if file does not already exist
if (!(Test-Path -Path "$DVDalpine")) {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }


## Download Ubunto iso
$outputPath = $DVDUBUNTU
$url = "https://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso"
$DVDUBUNTU = Join-Path $isofolder (Split-Path $url -Leaf) # extracts filename from download

# download if file does not already exist
if (!(Test-Path -Path "$DVDUBUNTU")) {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }

## change the name to the switch that has access to the internet.
##  Hyper-V > Virtual Switch Manager > Identify the Switch names

$switchInternet="internet" 


## this subnet is used for this example this is a label so any other subnet can be used for the VM's.
$switchprivate="Private 192.168.100.0/24" 
##
### Creates new private network.
$existingSwitch = Get-VMSwitch -Name $switchprivate -SwitchType Internal -ErrorAction SilentlyContinue
if ($null -eq $existingSwitch.name) {
    New-VMSwitch -Name $switchprivate -SwitchType Internal -Notes "created for k8s-lab project "
} else {
    Write-Host "The switch '$switchprivate' already exists."
}

# VM creation begins here.

foreach ($vm in $vms) {
    $vmfolder = "$workingfolder\VirtualMachines\$($vm.VMName)"
    # Intialize variable typess to enable provisioning of Hyper-V VM.   
    [int64]$RAM=$null
    [int64]$RAMmax=$null
    [System.UInt64]$Disksize1=$null
    [System.UInt64]$Disksize2=$null

    # Check if the VM already exists
    $existingVM = Get-VM -Name  $vm.VMName -ErrorAction SilentlyContinue

    if ($null -eq $existingVM) {
        # VM does not exist, create a new one
        New-VM -Name  $vm.VMName -Generation 2 -Path $vmFolder
        $RAM = (1GB * $vm.MemoryGB)
        $RAMmax = (2GB * $vm.MemoryGB)
        Set-VM -Name  $vm.VMName -MemoryStartupBytes $RAM 
        Set-VM -VMName  $vm.VMName -ProcessorCount $vm.CPUCount # -DynamicMemory -MemoryMaximumBytes $RAMmax -MemoryStartupBytes $RAM
        Write-Host $vm.VMName "created successfully."

    # Hard disk Primary OS
    [System.UInt64]$Disksize1=([long]$vm.DiskSizeGB1 * 1GB)
    [System.UInt64]$Disksize2=([long]$vm.DiskSizeGB2 * 1GB)
    $diskPath1 = Join-Path $vmfolder "$($vm.VMName)-hdd1.vhdx"
    New-VHD -Path $diskPath1 -SizeBytes $Disksize1 -Dynamic 
    Add-VMHardDiskDrive -VMName $vm.VMName -Path $diskPath1 -ControllerType SCSI -ControllerLocation 0

    # Additional Hard disk
    if ($vm.DiskSizeGB2 -ne "") {
    $diskPath2 = Join-Path $vmfolder "$($vm.VMName)-hdd2.vhdx"
    New-VHD -Path $diskPath2 -SizeBytes $Disksize2 -Dynamic
    Add-VMHardDiskDrive -VMName $vm.VMName -Path $diskPath2 -ControllerType SCSI -ControllerLocation 1
    } else {
    "Disk2 not required"
    }

    # Load ISO drive for installation
    $isoPath = Join-Path "$workingfolder\iso" $($vm.ISOPath)
    add-VMDvdDrive -VMName $vm.VMName -Path $isoPath -ControllerLocation 3

    #Network adapters
    if($vm.NetworkSwitch1 -ne "") {
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch1
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch2
    } else {
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch2
    }
    #remove the network adapter without a SwitchName from the VM
    get-VMNetworkAdapter  -VMName  $vm.VMName | Where-Object {$_.SwitchName -ne $switchprivate -and $_.SwitchName -ne $switchInternet  } |Remove-VMNetworkAdapter   

    # Set boot order
    $bootOrder = @()
    if ($vm.BootOrder -eq "DVD") {
        $bootOrder += Get-VMDvdDrive -VMName $vm.VMName
        $bootOrder += Get-VMHardDiskDrive -VMName $vm.VMName | Where-Object { $_.ControllerLocation -eq 0 }
    }
    elseif ($vm.BootOrder -eq "Network") {
        $bootOrder += Get-VMNetworkAdapter -VMName $vm.VMName| Where-Object {$_.SwitchName -eq $switchprivate}
        $bootOrder += Get-VMHardDiskDrive -VMName $vm.VMName | Where-Object { $_.ControllerLocation -eq 0 }
    }


    # Set the boot order for the VM
    Set-VMFirmware -VMName $vm.VMName -BootOrder $bootOrder -EnableSecureBoot Off
    # Disable checkpoints 
    Set-VM -Name $vm.VMName -CheckpointType Disabled

    } else {
        Write-Host $vm.VMName "already exists."
    }



}
