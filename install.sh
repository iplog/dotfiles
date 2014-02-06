echo "Your dotfiles installation"
echo "Please enter some details: "

while true; do
  read -p "First name (git): " firstName
  read -p "Last name (git): " lastName
  read -p "Email (git): " email
  echo "Thanks!\n"
  echo "First name: ${firstName}"
  echo "Last name: ${lastName}"
  echo "Email: ${email}\n"
  read -p "Are the details ok? y/n " yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) ;;
      * ) echo "Please answer yes or no.";;
    esac
done

# Create git conf file
sed -e s/{{firstName}}/${firstName}/ \
-e s/{{lastName}}/${lastName}/ \
-e s/{{email}}/${email}/ git/gitconfig.sample > git/gitconfig

# install oh-my-zsh
if [ ! -r ~/.oh-my-zsh ]; then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# create arrays
declare -a confFiles=(
  git/gitconfig
  zsh/zshrc
  oh-my-zsh/perso.zsh-theme
)

declare -a dests=(
  ~/.gitconfig
  ~/.zshrc
  ~/.oh-my-zsh/custom/perso.zsh-theme
)

# Get current working directory
CWD=$(pwd)

# create all the files
for i in ${!confFiles[@]}; do
  confFile=${confFiles[$i]}
  dest=${dests[$i]}

  # check for existing files and back them up
  if [ -f ${dest} ] && [ ! -f ${dest}.orig ]; then
    mv ${dest} ${dest}.orig
  elif [ -h ${dest} ]; then
    rm ${dest}
  fi

  # create symlink
  ln -s ${CWD}/${confFile} ${dest}

  echo "${dest} installed!"
done
