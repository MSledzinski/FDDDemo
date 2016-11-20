###############################################
# Windows Server 2016 (CTP3+)

# Install OneGet provider for PS
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# Install Docker module
Install-Package -Name docker -ProviderName DockerMsftProvider

# Restart
Restart-Computer -Force


###############################################
# Windows 10 (Anniversary update) (Pro+)

# Ensure system updates installed

# Enable containers feature
Enable-WindowsOptionalFeature -Online -FeatureName containers -All

# Enable Hyper-V as it is only possible isolation mode
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

#Restart
Restart-Computer -Force

# Download docker 
# NOTE: it will use release from Docker Beta channel, there is also Stable channel
Invoke-WebRequest "https://master.dockerproject.org/windows/amd64/docker-1.13.0-dev.zip" -OutFile "$env:TEMP\docker-1.13.0-dev.zip" -UseBasicParsing

# Expand and install
Expand-Archive -Path "$env:TEMP\docker-1.13.0-dev.zip" -DestinationPath $env:ProgramFiles
$env:path += ";c:\program files\docker"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)

# Start service
dockerd --register-service
Start-Service Docker
