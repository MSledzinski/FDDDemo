function Show-RuntimeVersions
{
   [CmdletBinding()]
   Param()

    Write-Host "WINDOWS" 
    Get-WmiObject -class Win32_OperatingSystem |
     Select-Object Caption, OSArchitecture, ServicePackMajorVersion,@{Expression={(Get-CimInstance Win32_OperatingSystem).Version}; Label="Build"} |
     Format-List

    Write-Host "DOCKER"
    docker version
}

function Get-ContainersIpAddresses
{
    [CmdletBinding()]
    Param()

    $runningIds = docker ps -q

    foreach($id in $runningIds)
    {
        $ip = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id
    
        Write-Output (New-Object -TypeName PSObject -Property @{ "ContainerIP" = $ip; "ContainerID" = $id })
    }
}

function Find-SampleWebAppFileInLayers
{
    [CmdletBinding()]
    Param()

    $file = Get-ChildItem -Path 'C:\ProgramData\docker\windowsfilter' 'SampleWebAppWithDocker.sln' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    # file.Build.Layer
    $path = $file.Directory.Parent.Parent.FullName
    & explorer $path

}

function Stop-AllContainers
{
    [CmdletBinding()]
    Param()

    $runningIds = docker ps -q

    foreach($id in $runningIds)
    {
        docker stop $id
    }
}

function Start-ContainerIpInChrome
{
    [CmdletBinding()]
    Param()

    Get-ContainersIpAddresses | ForEach-Object { & 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' "$($_.ContainerIP)"}
}

function Clear-ContainerImages
{ 
    [CmdletBinding()]
    Param()

     # remove stopped containers
     docker rm $(docker ps -a -q)

     # removed non tagged images
     $noneImages = docker images | ForEach-Object { 
   
        $tokens = ([string]$_).Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)

        if($tokens[0] -eq '<none>'){
            $tokens[2]      
        }
     }

 $noneImages | ForEach-Object { docker rmi $_ }
}

function Test-MemoryUsage
{
    [cmdletbinding()]
    Param()

    $os = Get-Ciminstance Win32_OperatingSystem
    $pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100, 2)

    if ($pctFree -ge 50) {
      $Status = "OK"
    }
    elseif ($pctFree -ge 12 ) {
     $Status = "Warning"
    }
    else {
      $Status = "Critical"
    }

    $os | Select @{Name = "Status";Expression = {$Status}},
    @{Name = "PrctFree"; Expression = {$pctFree}},
    @{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
    @{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
}

function Show-MemoryUsage
{ 
    [cmdletbinding()]
    Param()
 
    $data = Test-MemoryUsage
 
    Switch ($data.Status) {
        "OK" { $color = "Green" }
        "Warning" { $color = "Yellow" }
        "Critical" {$color = "Red" }
    }
 
    Write-Host "Memory Check" -foregroundColor Cyan
 
    $data | Format-Table @{Expression={$_.PrctFree};Label="% Free";},@{Expression={$_.FreeGB};Label="Free [GB]";},@{Expression={$_.TotalGB};Label="Total [GB]"} -AutoSize | Out-String | Write-Host -ForegroundColor $color 
}

function Get-DockerRunCommandToClip
{
    "docker run -d aspmvc-demo" | clip
}

function Get-DockerBuidlCommandToClip
{
    "docker build -t aspmvc-demo ." | clip
}

function Start-DockerBuildCommandDemo
{
    Push-Location
    Set-Location (Join-Path $PSScriptRoot "../SampleWebAppWithDocker")

    docker build -t aspmvc-demo .

    Pop-Location
}

function Start-DockerRunCommandDemo
{
    Push-Location
    Set-Location (Join-Path $PSScriptRoot "../SampleWebAppWithDocker")

    docker run -d aspmvc-demo 

    Pop-Location
}


Export-ModuleMember -Function * 