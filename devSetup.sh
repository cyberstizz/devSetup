#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages on Linux
install_linux_packages() {
    sudo apt update
    sudo apt install -y git curl build-essential python3 default-jdk default-jre \
    gcc g++ make php composer nodejs npm openjdk-11-jdk code android-studio intellij-idea-community postgresql pgadmin4 docker.io docker-compose
}

# Function to install Homebrew and packages on macOS
install_mac_packages() {
    # Install Homebrew if not installed
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages
    brew install git curl python3 openjdk node npm gcc php composer docker docker-compose
    brew install --cask visual-studio-code android-studio intellij-idea postgresql pgadmin4
}

# Function to install packages on Windows (using Chocolatey)
install_windows_packages() {
    # Install Chocolatey if not installed
    if ! command_exists choco; then
        echo "Installing Chocolatey..."
        powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
        "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    fi

    # Install packages
    choco install -y git nodejs-lts python3 openjdk php composer vscode androidstudio intellijidea-community postgresql pgadmin4 docker-desktop
}

# Detect OS and install packages accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_packages
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_packages
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    install_windows_packages
else
    echo "Unsupported OS type: $OSTYPE"
    exit 1
fi

# Install nvm, node, npm
if ! command_exists nvm; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
fi

# Connect to GitHub
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating RSA key for GitHub..."
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
fi

echo "This is the key to paste into your GitHub:"
cat "$HOME/.ssh/id_rsa.pub"

# Install global npm packages
npm install -g create-react-app @angular/cli typescript mocha chai

# Install Spring Boot
if ! command_exists spring; then
    echo "Installing Spring Boot..."
    curl -o spring-boot-cli.zip https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/2.5.2/spring-boot-cli-2.5.2-bin.zip
    unzip spring-boot-cli.zip -d spring-boot-cli
    export PATH=$PATH:$(pwd)/spring-boot-cli/spring-2.5.2/bin
fi

# Install ASP.NET Core (for Windows only)
if [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Installing ASP.NET Core..."
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    "iex ((New-Object System.Net.WebClient).DownloadString('https://dot.net/v1/dotnet-install.ps1'))"
    export PATH=$PATH:$HOME/.dotnet/tools
    dotnet tool install --global Microsoft.AspNetCore.Mvc
fi

echo "Development environment setup complete!"
