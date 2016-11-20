Simple WebApplication to demonstrate Windows Containers and Docker tools


To start using Windows Containers:
1. Ensure OS version - Windows Server 2016 (CTP3+), Windows 10 (Anniversary update, Professional or Enterprise)
2. Follow instructions from Scripts/HowToStart.ps1*
(More details [Windows Containers Quick Start](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start))


To run this example
1. Open cmd or powershell console
2. Go to SampleWebAppWithDocker folder
3. Run: docker build -t aspmvc-demo .
4. Once container is built, run: docker run -d aspmvc-demo  
5. To list running containers use: docker ps
6. To stop container run: docker stop <ID> (ID can be fetched from 'docker ps' command output)*
(Detils about [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/) )

Notes:*
1. Scripts/FddHelpers.psm1 contains helper powershell functions used during demonstration (do not treat it as PS best practice :) )

2. If image build is failing with 'cannot resolve DNS' error, try:
  - open Powershell console as admin
  - run: Stop-Service docker
  - run: notepad C:\ProgramData\Docker\config\daemon.json
  - add to file Google DNS ip, in form of: { "dns": ["8.8.8.8"] }   
  - save and close
  - run: Start-Service docker
   
3. File .dockerignore should also ingore nuget packages folder - it is not, to reduce container build time during demo