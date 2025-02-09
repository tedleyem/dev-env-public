#Zsetup script to setup a macbook for a dev environment
#brew_pkgs=(awscli clocker docker docker-compose gh itsycal jq libreoffice lsd packer py-tf-utils pip ripgrep precommit zsh-autosuggestions)
brew_pkgs=(ansible ansible-lint docker gh git itsycal magic-wormhole lsd pip zsh-autosuggestions)

cmd=$1
flags=${@:2:#}
brewexists=$(which brew)
pipexists=$(which pip) 
brewlist=$(brew list)
   
if [[ $cmd == "init" ]]; then
  # setup projects directory
  local homels=$(ls ~)
  if [[ $homels != *"projects"* ]]; then
    mkdir ~/projects
  else
    echo "project directory : already found in home directory"
    echo "skipping..."
fi

# install homebrew
if [[ $brewexists == *"not found"* ]]; then
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
   echo "brew : already installed"
   echo "skipping..."
fi
    
# Install PIP 
if [[ $pipexists == *"not found"* ]]; then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py
else
  echo "pip : already installed"
  echo "skipping..."
fi

# Install Homebrew Packages 
for i in `$brew_pkgs[@]`; do 
  print -r -- $i
# install brew packages for loop  
  if [[ $brewlist == *$i* ]]; then
     echo " $i : already installed"
     echo "skipping..."
   else
     brew install $i
   fi  

  local brewlist=$(brew list)
  # install ripgrep
  if [[ $brewlist == *"ripgrep"* ]]; then
    echo "${CYAN}- ${YELLOW}ripgrep ${NOCOLOR}: already installed"
    echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
  else
    brew install ripgrep
  fi
  # install pyenv
  if [[ $brewlist == *"pyenv"* ]]; then
    echo "${CYAN}- ${YELLOW}pyenv ${NOCOLOR}: already installed"
    echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
  else
    brew install pyenv
  fi
  # install tfenv
  if [[ $brewlist == *"tfenv"* ]]; then
    echo "${CYAN}- ${YELLOW}tfenv ${NOCOLOR}: already installed"
    echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
  else
    brew install tfenv
  fi 
  # install awscli
  if [[ $brewlist == *"awscli"* ]]; then
    echo "${CYAN}- ${YELLOW}awscli ${NOCOLOR}: already installed"
    echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
  else
    brew install awscli
  fi

  # install github cli
  if [[ $brewlist == *"gh"* ]]; then
    local whichgh=$(which gh)
    if [[ $whichgh != *"not found"* ]]; then
      echo "${CYAN}- ${YELLOW}github cli ${NOCOLOR}: already installed"
      echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
    else
      brew install gh
    fi
  else
    brew install gh
  fi
    
  # install docker
  if [[ $brewlist == *"docker"* ]]; then
    local whichjq=$(which docker)
    if [[ $whichjq != *"not found"* ]]; then
      echo "${CYAN}- ${YELLOW}docker ${NOCOLOR}: already installed"
      echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
    else
      brew install docker
    fi
  else
    brew install docker
  fi
  # install docker-compose
  if [[ $brewlist == *"docker-compose"* ]]; then
    local whichjq=$(which docker-compose)
    if [[ $whichjq != *"not found"* ]]; then
      echo "${CYAN}- ${YELLOW}docker-compose ${NOCOLOR}: already installed"
      echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
    else
      brew install docker-compose
    fi
  else
    brew install docker-compose
  fi
    
  # install tfutils
  local piplist=$(pip list)
  if [[ $piplist == *"py-tf-utils"* ]]; then
    echo "${CYAN}- ${YELLOW}tfutils ${NOCOLOR}: already installed"
    echo "${CYAN}-- ${GREEN}skipping...${NOCOLOR}"
  else
    pip install py-tf-utils
  fi

echo "Setting up Vim Nerd Fonts"
cd ~/Library/Fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

echo "Setting up Vundle (Vim Plugin Manager) "
git clone https://gitlab.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
if [[ ! -f ~/.vimrc ]]; then
  echo "vimrc file NOT found!! "
  echo "Setting up vimrc"
  cp vimrc ~/.vimrc    
  vim +PluginInstall +qall
else 
  echo "vimrc file found"
  echo "Installing Vim Plugins" 
  vim +PluginInstall +qall
fi


echo "Running ansible playbook"
ansible-playbook playbook.yml 


