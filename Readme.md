---

# OneClickOneServer Setup Guide

Welcome to the OneClickOneServer setup guide. This guide will walk you through the steps to get your server up and running on Windows 10/11.

## Quick Start (Linux/macOS)

To download and run the setup script directly with curl:

```sh
curl -fsSL https://raw.githubusercontent.com/olliez-mods/OneClickOneServer/main/scripts/setup_direct.sh | bash
```

## Prerequisites

1. **(Optional) Enable PowerShell Execution Policy**

   In some cases, you might need to enable the PowerShell execution policy to run scripts. If you encounter issues, open PowerShell as an administrator and run the following command:
   ```powershell
   Set-ExecutionPolicy Unrestricted
   ```

   > **Note:** This step is often not required, but it is a common troubleshooting step if you face issues running the PowerShell scripts.

2. **Install Docker Desktop**

   Ensure you have Docker Desktop installed and running properly. You can download it from [Docker Desktop](https://www.docker.com/products/docker-desktop).

   > **Note:** Make sure Docker Desktop is running before proceeding with the setup.

## Setup Steps

1. **Configure Server Config**

   Review the `ContainerConfig.ini` file and update any necessary settings. This file contains configuration options for your server.

2. **Build the Server**

   Run the `BuildServer.ps1` script:
   - Right-click the `BuildServer.ps1` file and select "Run with PowerShell".
   - This script will create a Docker image, create a Docker container, and run it in setup mode.
   - The container will clone the OHOL repositories and build them. This process may take some time.

3. **Start the Server**

   Run the `RunServer.ps1` script:
   - Right-click the `RunServer.ps1` file and select "Run with PowerShell".
   - This script will start the server.

   > **Note:** When in persistent mode, the `RunServer.ps1` script might not track the logs of the server. To view the logs:
   > 1. Open Docker Desktop.
   > 2. Skip past any prompts until you reach the home screen.
   > 3. Select "Containers" from the menu on the left.
   > 4. Select "ocos" to open the container.
   > 5. You can now view the logs.

## Additional Resources

- [Video Tutorial](https://youtu.be/Ovkx85V-3-M)

For any questions or support, feel free to join the OHOL Discord server and ping @OliverZ.

---
