
# Test folder
$InstallLocation = "F:\Program Files\go-jsonnet_0.20.0_Windows_i386"

# To add folder to PATH
 $persistedPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine) -split ';'
   if ($persistedPath -notcontains $InstallLocation) {
       $persistedPath = $persistedPath + $InstallLocation | where { $_ }
       [Environment]::SetEnvironmentVariable('Path', $persistedPath -join ';', [EnvironmentVariableTarget]::Machine)
     }

#To verify if PATH isn't already added
    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $InstallLocation) {
        $envPaths = $envPaths + $InstallLocation | where { $_ }
        $env:Path = $envPaths -join ';'
    }

