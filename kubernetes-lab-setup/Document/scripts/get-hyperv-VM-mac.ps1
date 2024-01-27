# Get the directory containing the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path


# Set the path to the script file
set-location  $scriptDirectory
$output ="$scriptDirectory\autoinstall"
if((Test-Path -Path $output) -ne "True") {New-Item -Path $output -ItemType Directory}

# Get all virtual machines
$vms = Get-VM

# Iterate through each virtual machine
foreach ($vm in $vms) {
    # Get MAC address of the first network adapter
    $macAddress = $vm | Get-VMNetworkAdapter | Select-Object -First 1 | Select-Object -ExpandProperty MacAddress

    # Get server name (Hyper-V host name)
    $serverName = $env:COMPUTERNAME

    # Output results
    Write-Host "VM Name: $($vm.Name)"
    Write-Host "MAC Address: $macAddress"
    Write-Host "Server Name: $serverName"

    # Check if MAC address is 00:00:00:00:00:00
    if ($macAddress -eq '000000000000') {
        Write-Host "Starting the VM to generate a valid MAC address..."
        Start-VM -Name $vm.Name
        # You might want to add a sleep here to allow time for the VM to generate a valid MAC address
        # Start-Sleep -Seconds 60
        Stop-VM -Name $vm.Name -Force
        Write-Host "VM has been powered off after obtaining a valid MAC address."
    } else {
        Write-Host "MAC address is valid. No action needed."
    }

    Write-Host "----------------------"
}

Clear-Content .\mac-address-list.csv
foreach ($vm in $vms) {
    # Get MAC address of the first network adapter
    $macAddress = $vm | Get-VMNetworkAdapter | Select-Object -First 1 | Select-Object -ExpandProperty MacAddress

    # Remove "k8s-" prefix from the VM name
    $vmName = $vm.Name -replace '^k8s-', ''

    # Format DHCP configuration with MAC address in XX:XX:XX:XX:XX:XX format
    $formattedMacAddress = ($macAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1:$2:$3:$4:$5:$6')
    $formattedMacAddressfn = ($macAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1-$2-$3-$4-$5-$6')

    # Convert MAC address to lowercase
    $formattedMacAddressLower = $formattedMacAddress.ToLower()
    $formattedMacAddressfnLower = $formattedMacAddressfn.ToLower()

    $dhcpConfig = @"
host $vmName {
    hardware ethernet $formattedMacAddress;
    fixed-address 192.168.100.250;
    option host-name "$vmName";
}
"@
    $mac = " $vmName,$formattedMacAddressfnLower,192.168.100.250"


    # Output DHCP configuration
    #Write-Host $dhcpConfig
    Write-Host $mac 
    $mac | Out-File   $output\mac-address-list.csv -Append
    #$mac | Out-File   ".\srv\autoinstall\node\user-data-$formattedMacAddressfn"
    $userdatafile="$output\user-data-$formattedMacAddressfnLower"
    if (-not (Test-Path $userdatafile)) {
    # File doesn't exist, create it
    New-Item -ItemType File -Path $userdatafile 
    Write-Host "File created: $userdatafile"
}
    if (-not (Test-Path $userdatafile-$vmName)) {
    # File doesn't exist, create it
    New-Item -ItemType File -Path $userdatafile-$vmName 
    Write-Host "File created: $userdatafile-$vmName"
} 
}
