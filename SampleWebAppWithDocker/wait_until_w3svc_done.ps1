# warmup IIS
Invoke-WebRequest 127.0.0.1 -UseBasicParsing

# wait unti w3svc is done
while ((Get-Service -Name 'w3svc').Status -eq "Running" ) 
{
    Start-Sleep -Seconds 10
}