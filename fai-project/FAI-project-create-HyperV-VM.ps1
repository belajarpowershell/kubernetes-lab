# date January 2023
# script to generate HyperV VM image for 1 x Management node and 2 x k3s single nodes
# This script will create the VM with the specifications below
# CPU 1
# Memory 1GB
# customize as required
# Validated
# 1. Drive letter ( chose the drive with most disk space)
# 2. The iso filename to match downloaded iso name 
# 3. I prefixed "demo-" to the hostnames  to record a video, this can be removed to shorten the name.

# ExecutionPolicy
# if you have not executed a Powershell script before it may have been disabled
# Familiarize yourselve with the impact of doing this.
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# create working folder
# this script will default to  f:\fai-project-lab\
$workingfolder = "f:\fai-project-lab"
if (!(Test-Path -Path "$workingfolder" -PathType Container)) {
        New-Item -Path "$workingfolder" -ItemType Directory
    }
    

### Download the ISO images to the folder listed here.
$isofolder = "$workingfolder\fai-project\iso\"
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
$outputPath = $DVDFAI
$url = "https://fai-project.org/fai-cd/faicd64-large_6.0.3.iso"
$DVDFAI = Join-Path $isofolder (Split-Path $url -Leaf) # extracts filename from downloadurl #$DVDFAI="$isofolder\faicd64-large_6.0.3.iso"

# download if file does not already exist
if (!(Test-Path -Path "$DVDFAI")) {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }


##
# These are the Hyper-V virtual switch that must be created
## all the VM's will have both internet and Private switch connected.
## the internet switch will act as our management network so we are able to access the 


## change this to the switch that has access to the internet.
$switchInternet="internet" 

## this subnet is used for this example this is a label so any other subnet can be used for the VM's.
$switchprivate="Private 192.168.33.0/24" 

##

### Creates new private network.

$existingSwitch = Get-VMSwitch -Name $switchprivate -SwitchType Internal -ErrorAction SilentlyContinue
if ($existingSwitch -eq "$null") {
    New-VMSwitch -Name $switchprivate -SwitchType Internal -Notes "created for Fai-project Network "
} else {
    Write-Host "The switch '$switchprivate' already exists."
}


$hostnamelist=("alpine1,alpine2").Split(",")
#get-vm | Remove-VM -Confirm $false

foreach ($vmname in $hostnamelist){

        $vmfolder = "$workingfolder\VirtualMachines\$vmname\"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$vmfolder"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$vmfolder\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$vmfolder\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "$DVDalpine" # validate iso filename to match downloaded name 
        


        if ($vmname -eq "alpine1") {
            # Connect to HyperV Switch connected to External network.
            connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switchInternet
            # add new NIC for Private Network
            add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
            $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where-object{$_.SwitchName -eq $switchprivate}
            $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        } else {
            add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
            $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where-object{$_.SwitchName -eq $switchprivate}
            $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        }
        # Turn off Secure Boot to simplify setup and set boot order  ( for generation 2 VM type)
        #Set-VMFirmware $vmname -BootOrder  $(get-VMDvdDrive  $vmname), $(get-VMHardDiskDrive $vmname | where {$_.ControllerLocation -eq "0"})  -EnableSecureBoot Off
        if ($vmname -eq "alpine1") {
            Set-VMFirmware $vmname -BootOrder  $(get-VMDvdDrive  $vmname), $(get-VMHardDiskDrive $vmname | Where-Object{$_.ControllerLocation -eq "0"})  -EnableSecureBoot Off
        } else {
            Set-VMFirmware "$vmname" -EnableSecureBoot Off -BootOrder $vmNetworkAdapter, $vmHardDiskDrive
        }

}


$hostnamelist=("faiserver").Split(",")

foreach ($vmname in $hostnamelist){
        $vmfolder = "$workingfolder\VirtualMachines\$vmname\"
        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$vmfolder"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$vmfolder\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$vmfolder\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0


        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "$DVDFAI" # validate iso filename to match downloaded name 

        # Connect to HyperV Switch connected to External network.
        #connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switchInternet
        #Remove External network NIC from VM
        get-VMNetworkAdapter  -VMName $vmname | where {$_.SwitchName -ne $switchprivate } |Remove-VMNetworkAdapter        
        # add new NIC for Private Network
        add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
        $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where-object{$_.SwitchName -eq $switchprivate}
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        # Turn off Secure Boot to simplify setup and set boot order ( for generation 2 VM type)
        $vmDvdDrive = get-VMDvdDrive  $vmname
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        Set-VMFirmware $vmname -BootOrder  $vmDvdDrive, $vmHardDiskDrive -EnableSecureBoot Off

}


$hostnamelist=("fai-test").Split(",")

foreach ($vmname in $hostnamelist){
        $vmfolder = "$workingfolder\VirtualMachines\"
        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$vmfolder"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$vmfolder\$vmname\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$vmfolder\$vmname\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        
        # Hard disk secondary for k3s data 
        New-VHD -Path "$vmfolder\$vmname\$vmname-hddadd.vhdx" -SizeBytes 60GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$vmfolder\$vmname\$vmname-hddadd.vhdx" -ControllerType SCSI  #-ControllerLocation 1
        
        #Remove External network NIC from VM
        get-VMNetworkAdapter  -VMName $vmname | where {$_.SwitchName -ne $switchprivate } |Remove-VMNetworkAdapter
        # add new NIC for Private Network
        add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
        # Turn off Secure Boot to simplify setup and set boot order ( for generation 2 VM type)
        
        $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where-object{$_.SwitchName -eq $switchprivate}
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0

        Set-VMFirmware "$vmname" -EnableSecureBoot Off -BootOrder $vmNetworkAdapter, $vmHardDiskDrive
}



