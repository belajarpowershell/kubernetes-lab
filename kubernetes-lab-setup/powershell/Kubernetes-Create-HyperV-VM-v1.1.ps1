# create working folder
# this script will default to  F:\kubernetes-project-lab
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
<#
example content of "vms.csv"

VMName,NetworkSwitch1,NetworkSwitch2,DiskSizeGB1,DiskSizeGB2,CPUCount,MemoryGB,ISOPath,BootOrder
ak8s-alpine1,Internet,"Private 192.168.100.0/24",50,,1,1,alpine-standard-3.18.4-x86_64.iso,DVD
ak8s-loadbalancer,,"Private 192.168.100.0/24",50,,1,1,alpine-standard-3.18.4-x86_64.iso,DVD
ak8s-master1,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-master1,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-master2,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-master3,,"Private 192.168.100.0/24",50,,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-worker1,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-worker2,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-worker3,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network
ak8s-xsinglenode,,"Private 192.168.100.0/24",50,30,1,1,ubuntu-20.04.6-live-server-amd64.iso,Network

##
NetworkSwitch1 : this is the internet connection
NetworkSwitch2 : this is the private network "Private 192.168.100.0/24"
ISOPath : if there is a DVD loaded the iso name is listed here.
BootOrder : 
DVD > First Boot DVD, Second Boot HDD
Network > First Boot Network  "Private 192.168.100.0/24" , Second Boot HDD
#>

# Get the directory containing the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path


# Set the path to the CSV file
$csvPath = "F:\OneDrive\001-Devops-Learning\kubernetes-lab\kubernetes-lab-setup\powershell\vms.csv"

# Read the CSV file
$vms = Import-Csv -Path $csvPath

# create working folder
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


$outputPath = $DVDalpine
$url = "https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-standard-3.18.4-x86_64.iso"
$DVDalpine=Join-Path $isofolder (Split-Path $url -Leaf) # extracts filename from downloadurl

# download if file does not already exist
if (!(Test-Path -Path "$DVDalpine")) {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }

#Invoke-WebRequest -Uri $url -OutFile $outputPath
$outputPath = $DVDUBUNTU
$url = "https://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso"
$DVDUBUNTU = Join-Path $isofolder (Split-Path $url -Leaf) # extracts filename from downloadurl #$DVDUBUNTU="$isofolder\faicd64-large_6.0.3.iso"

# download if file does not already exist
if (!(Test-Path -Path "$DVDUBUNTU")) {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }
## change this to the switch that has access to the internet.
$switchInternet="internet" 

## this subnet is used for this example this is a label so any other subnet can be used for the VM's.
$switchprivate="Private 192.168.100.0/24" 

##

### Creates new private network.

$existingSwitch = Get-VMSwitch -Name $switchprivate -SwitchType Internal -ErrorAction SilentlyContinue
if ($existingSwitch.name -eq $null) {
    New-VMSwitch -Name $switchprivate -SwitchType Internal -Notes "created for k8s-lab project "
} else {
    Write-Host "The switch '$switchprivate' already exists."
}

   

[int64]$RAM=$null
[int64]$RAMmax=$null
[int64]$Disksize1=$null
[int64]$Disksize2=$null

foreach ($vm in $vms) {
    $vmfolder = "$workingfolder\VirtualMachines\$($vm.VMName)"
    [int64]$RAM=$null
    [int64]$RAMmax=$null
    [System.UInt64]$Disksize1=$null
    [System.UInt64]$Disksize2=$null
    # VM CPU and Memory config
    New-VM -Name $vm.VMName -Generation 2 -Path $vmfolder
    
    $RAM = (1GB *  $vm.MemoryGB)
    $RAMmax=(2GB * $vm.MemoryGB)
    set-VM -Name $vm.VMName -MemoryStartupBytes $RAM 
    Set-VM -VMName $vm.VMName -ProcessorCount $vm.CPUCount # -DynamicMemory -MemoryMaximumBytes $RAMmax -MemoryStartupBytes $RAM
    "aaaa"
    # Hard disk Primary OS
    [System.UInt64]$Disksize1=([long]$vm.DiskSizeGB1 * 1GB)
    [System.UInt64]$Disksize2=([long]$vm.DiskSizeGB2 * 1GB)

    $diskPath1 = Join-Path $vmfolder "$($vm.VMName)-hdd1.vhdx"
    New-VHD -Path $diskPath1 -SizeBytes $Disksize1 -Dynamic 
    Add-VMHardDiskDrive -VMName $vm.VMName -Path $diskPath1 -ControllerType SCSI -ControllerLocation 0
    "bbbbb"
    # Additional Hard disk

    if ($vm.DiskSizeGB2 -ne "") {
    $diskPath2 = Join-Path $vmfolder "$($vm.VMName)-hdd2.vhdx"
    New-VHD -Path $diskPath2 -SizeBytes $Disksize2 -Dynamic
    Add-VMHardDiskDrive -VMName $vm.VMName -Path $diskPath2 -ControllerType SCSI -ControllerLocation 1
    } else {
    "Disk2 not required"
    }

    "ccccc"
    # Load ISO drive for installation
    $isoPath = Join-Path "F:\kubernetes-project-lab\iso" $($vm.ISOPath)
    add-VMDvdDrive -VMName $vm.VMName -Path $isoPath -ControllerLocation 3

    #Network adapters
    if($vm.NetworkSwitch1 -ne "") {
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch1
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch2
    } else {
    add-VMNetworkAdapter -VMName $vm.VMName -SwitchName $vm.NetworkSwitch2
    }
    #remove the network adapter withour a SwithcName
    get-VMNetworkAdapter  -VMName  $vm.VMName | where {$_.SwitchName -ne $switchprivate -and $_.SwitchName -ne $switchInternet  } |Remove-VMNetworkAdapter   
    "ddddd"
    # Set boot order
    $bootOrder = @()
    if ($vm.BootOrder -eq "DVD") {
        $bootOrder += Get-VMDvdDrive -VMName $vm.VMName
        $bootOrder += Get-VMHardDiskDrive -VMName $vm.VMName | Where-Object { $_.ControllerLocation -eq 0 }
    }
    elseif ($vm.BootOrder -eq "Network") {
        $bootOrder += Get-VMNetworkAdapter -VMName $vm.VMName| where {$_.SwitchName -ne $switchprivate}
        $bootOrder += Get-VMHardDiskDrive -VMName $vm.VMName | Where-Object { $_.ControllerLocation -eq 0 }
    }


    # Set the boot order for the VM
    Set-VMFirmware -VMName $vm.VMName -BootOrder $bootOrder -EnableSecureBoot Off

}
$bootOrder