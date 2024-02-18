How to setup and run OneClickOneServer

All needed prerequisites should be installed automaticly (you may need to restart powershell a coupld time)
If you come accross errors please report them :D

1. Configure server Config
    Make sure that you look over "ContainerConfig.ini" and update any needed settings

2. Run BuildServer.ps1
    Right click the ps1 file and "run with Powershell" this will go through the proccess of:
    enabling WSL
    Installing Docker Desktop
    Creating Docker Image
    Creating Docker container and running it in setup mode
    Once the ocntainer starts, it should clone the OHOL repositories and then build them (this may take a while)

3. Run RunServer.ps1
    Now run the RunServer.ps1 Powershell script,  this will start the server.
    Note: The RuneServer script does not track the logs of the server, to view them:
        Open docker Desktop (Skip past any prompts until you get to the home screen)
        Select "Containers" from the menu on the left
        Select "ocos" to open up the container
        You can now view the logs


Notes:
    