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
https://learn.microsoft.com/en-us/powershell/module/hyper-v/new-vm?view=windowsserver2022-ps
https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell

$hostnamelist=("demo-k3s-management-lab-01").Split(",")

foreach ($vmname in $hostnamelist){

        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 512MB -Generation 2 -Path "D:\Hyper-V\Virtual Machines\$vmname"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 512MB

        # Hard disk Primary OS 
        New-VHD -Path "D:\Hyper-V\Virtual hard disks\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "D:\Hyper-V\Virtual hard disks\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "D:\Downloads\ubuntu-20.04.5-live-server-amd64.iso" # validate iso filename to match downloaded name 
        
        # Connect to HyperV Switch connected to External network.
        Connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switch
        
        # Turn off Secure Boot to simplify setup and set boot order  ( for generation 2 VM type)
        Set-VMFirmware $vmname -BootOrder  $(get-VMHardDiskDrive $vmname), $(get-VMDvdDrive  $vmname) -EnableSecureBoot Off


}


$hostnamelist=("demo-k3s-single-lab-01,demo-k3s-single-lab-02").Split(",")

foreach ($vmname in $hostnamelist){

        $switch="ExternalNetwork"
        # VM CPU and Memory config
        New-VM -Name $vmname -MemoryStartupBytes 512MB -Generation 2 -Path "D:\Hyper-V\Virtual Machines\$vmname"
        Set-VM -VMName $vmname -ProcessorCount 1 -DynamicMemory -MemoryMaximumBytes 2GB  -MemoryStartupBytes 512MB

        # Hard disk Primary OS 
        New-VHD -Path "D:\Hyper-V\Virtual hard disks\$vmname-hdd1.vhdx" -SizeBytes 50GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "D:\Hyper-V\Virtual hard disks\$vmname-hdd1.vhdx" -ControllerType SCSI   -ControllerLocation 0
        
        # Hard disk secondary for k3s data 
        New-VHD -Path "D:\Hyper-V\Virtual hard disks\$vmname-hddadd.vhdx" -SizeBytes 60GB -Dynamic
        Add-VMHardDiskDrive -VMName $vmname -Path "D:\Hyper-V\Virtual hard disks\$vmname-hddadd.vhdx" -ControllerType SCSI  #-ControllerLocation 1

        # Load ISO drive for installation
        add-VMDvdDrive -VMName $vmname  -Path "D:\Downloads\ubuntu-20.04.5-live-server-amd64.iso" # validate iso filename to match downloaded name 

        # Connect to HyperV Switch connected to External network.
        Connect-VMNetworkAdapter -VMName $vmname  -SwitchName $switch

        # Turn off Secure Boot to simplify setup and set boot order ( for generation 2 VM type)
        Set-VMFirmware $vmname -BootOrder  $(get-VMHardDiskDrive $vmname | where {$_.ControllerLocation -eq "0"}), $(get-VMDvdDrive  $vmname) -EnableSecureBoot Off

}

