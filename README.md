# Contracts

Directory of our contracts.


## Installation

1. Clone this repository
    ```
    git clone git@github.com:RigoBlock/contracts.git
    cd contracts
    ```

2. Install dependencies, make sure you have NodeJS v7+ installed:
    ```
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    sudo apt-get install -y nodejs
    ```
    ```
    npm install
    ```

## Testing

Go to your `contracts` directory, open a terminal and:

1. Run testrpc:
    ```
    cd node_modules/.bin
    testrpc
    ```

2. In a second terminal:
    ```
    cd node_modules/.bin
    truffle test
    ```

## Deployment

Steps:

1. run parity:
    ```
    parity --chain ropsten --author <address> --unlock <address> --password <password file>
    ```

2. In a second terminal:
    ```
    truffle migrate
    ```

