# !/bin/sh

# Check if rust is installed, if not install it
if ! command -v rustc &> /dev/null
then
    echo "Rust is not installed. Installing..."
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
else
    echo "Rust is already installed."
fi

# Check if git is installed, if not install it
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install git
else
    echo "Git is already installed."
fi

# Clone and setup circom
if [ ! -d "circom" ]; then
    git clone https://github.com/iden3/circom.git
    cd circom
    cargo build --release
    cargo install --path circom
    cd ..
else
    echo "Circom directory already exists. Skipping clone."
fi

# cd into 'magic-square' and npm install
if [ -d "magic-square" ]; then
    cd magic-square
    if ! command -v npm &> /dev/null
    then
        echo "npm is not installed. Please install Node.js and npm first."
        exit 1
    fi
    npm install
    cd ..
else
    echo "magic-square directory does not exist. Please check the directory name."
    exit 1
fi