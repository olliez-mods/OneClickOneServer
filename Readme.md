How to setup and run OneClickOneServer<br>

Note: Make sure you install Docker Desktop [Link](https://www.docker.com/products/docker-desktop/) and it is running properly!.<br>

1. Configure server Config<br>
    Make sure that you look over "ContainerConfig.ini" and update any needed settings<br>

2. Run BuildServer.ps1<br>
    Right-click the ps1 file and "run with Powershell" This will go through the process of:<br>
    - Creating Docker Image<br>
    - Creating a Docker container and running it in setup mode<br>
    Once the container starts, it should clone the OHOL repositories and then build them (this may take a while)<br>

3. Run RunServer.ps1<br>
    Now run the RunServer.ps1 Powershell script,  this will start the server.<br>
    Note: The RuneServer script does not track the logs of the server, to view them:<br>
        Open docker Desktop (Skip past any prompts until you get to the home screen)<br>
        Select "Containers" from the menu on the left<br>
        Select "ocos" to open up the container<br>
        You can now view the logs<br>

    
