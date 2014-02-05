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

# Get current working directory
CWD=$(pwd)

# Create git conf file
sed -e s/{{firstName}}/${firstName}/ \
-e s/{{lastName}}/${lastName}/ \
-e s/{{email}}/${email}/ git/gitconfig.sample > git/gitconfig

# check for existing files and back them up
if [ -f ~/.gitconfig ]; then
  mv ~/.gitconfig ~/.gitconfig.orig
fi

# create symlink
ln -s ${CWD}/git/gitconfig ~/.gitconfig
