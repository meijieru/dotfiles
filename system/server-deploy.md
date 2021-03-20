# Deploy on new server

- Add new sudo user on ubuntu.
    ```sh
    sudo adduser ${username}
    sudo usermod -aG sudo ${username}
    chsh -s /bin/zsh ${username}
    ```

- Upload server ssh key.
    - Usually copy from other machine.
- Deploy dotfiles
    ```sh
    mkdir -p ~/workspace/other
    cd ~/workspace/other
    git clone git@github.com:meijieru/dotfiles.git
    cd dotfiles
    git checkout server
    ./install-dotfiles
    ```
- Anaconda install
    - Download latest anaconda from `https://www.anaconda.com/distribution/`

    ```sh
    mkdir ~/lib
    cd ~/lib
    wget ${anaconda_url}
    bash ${anaconda_path}
    ```

- Install neovim
    - nodejs, download from `https://nodejs.org/zh-cn/download/`
        ```sh
        cd ${node_root}
        ln -s `realpath bin/node` ~/.local/bin/node
        ln -s `realpath bin/npm` ~/.local/bin/npm
        ln -s `realpath bin/npx` ~/.local/bin/npx
        ```
    - yarn

        ```sh
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update && sudo apt-get install yarn
        ```

    - neovim
        ```sh
        sudo add-apt-repository ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install neovim
        pip install pynvim

        # In neovim
        :PlugInstall
        :UpdateRemotePlugins
        ```

- Install tmux
    ```sh
    sudo add-apt-repository ppa:pi-rho/dev
    sudo apt-get update
    ```
