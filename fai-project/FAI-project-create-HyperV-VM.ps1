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

#
# if you have not executed a Powershell script before it may have been disabled
# Familiarize yourselve with the impact of doing this.
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned


#Get-ExecutionPolicy 


### Download the ISO images to the folder listed here.
### you can change the path as per your own working folder.

$DVDalpine="F:\OneDrive\001-Devops-Learning\fai-project\iso\alpine-standard-3.18.4-x86_64.iso"
$DVDFAI="F:\OneDrive\001-Devops-Learning\fai-project\iso\faicd64-large_6.0.3.iso"
$workingfolder="F:\OneDrive\001-Devops-Learning\fai-project"

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
if ($existingSwitch -eq $null) {
    New-VMSwitch -Name $switchprivate -SwitchType Internal -Notes "created for Fai-project Network "
} else {
    Write-Host "The switch '$switchprivate' already exists."
}


$hostnamelist=("alpine1,alpine2").Split(",")
get-vm | Remove-VM -Confirm $false

foreach ($vmname in $hostnamelist){


        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$workingfolder\Virtual Machines\$vmname"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "$DVDalpine" # validate iso filename to match downloaded name 
        
        # Connect to HyperV Switch connected to External network.
        connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switchInternet
        # add new NIC for Private Network
        add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
        $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where{$_.SwitchName -eq $switchprivate}
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0

        # Turn off Secure Boot to simplify setup and set boot order  ( for generation 2 VM type)
        Set-VMFirmware $vmname -BootOrder  $(get-VMDvdDrive  $vmname), $(get-VMHardDiskDrive $vmname | where {$_.ControllerLocation -eq "0"})  -EnableSecureBoot Off


}


$hostnamelist=("faiserver").Split(",")

foreach ($vmname in $hostnamelist){

        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$workingfolder\Virtual Machines\"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0


        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "$DVDFAI" # validate iso filename to match downloaded name 

        # Connect to HyperV Switch connected to External network.
        connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switchInternet
        # add new NIC for Private Network
        add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate

        $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where{$_.SwitchName -eq $switchprivate}
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        # Turn off Secure Boot to simplify setup and set boot order ( for generation 2 VM type)
        $vmDvdDrive = get-VMDvdDrive  $vmname
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0
        Set-VMFirmware $vmname -BootOrder  $vmDvdDrive, $vmHardDiskDrive -EnableSecureBoot Off

}

$hostnamelist=("fai-test").Split(",")

foreach ($vmname in $hostnamelist){

        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 1GB -Generation 2 -Path "$workingfolder\Virtual Machines\$vmname"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 1GB

        # Hard disk Primary OS 
        New-VHD -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        
        # Hard disk secondary for k3s data 
        New-VHD -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hddadd.vhdx" -SizeBytes 60GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "$workingfolder\Virtual Machines\$vmname\$vmname-hddadd.vhdx" -ControllerType SCSI  #-ControllerLocation 1


        # Connect to HyperV Switch connected to External network.
        connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switchInternet
        # add new NIC for Private Network
        add-VMNetworkAdapter -VMName $vmname  -SwitchName $switchprivate
        # Turn off Secure Boot to simplify setup and set boot order ( for generation 2 VM type)
        
        $vmNetworkAdapter = get-VMNetworkAdapter -VMName $vmname | where{$_.SwitchName -eq $switchprivate}
        $vmHardDiskDrive = get-VMHardDiskDrive -VMName $vmname -ControllerType SCSI   -ControllerLocation 0

        Set-VMFirmware "$vmname" -EnableSecureBoot Off -BootOrder $vmNetworkAdapter, $vmHardDiskDrive
}



