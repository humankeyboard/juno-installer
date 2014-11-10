
#################################################
######## begining of configuration ##############
#################################################


# string to prefix your instances
# so you can identify them easily
NAME="juno"

# github information, so you can push code
GITHUB_USERNAME="username"
GITHUB_EMAIL="e-mail address"

# ssh url for your fork, example below
REPO="git@github.com:saltstackme/salt-sandbox.git"


# don't change these
PROVIDER="virtualbox"
VAGRANT_SERVER="localhost"


#################################################
######## end of configuration ###################
#################################################

if [ $VAGRANT_SERVER = "localhost" ]
    then

    echo
    echo == Configuring Vagrant Environment
    rm -rf ./${NAME}
    mkdir ./${NAME}
    git clone https://github.com/humankeyboard/juno-installer.git ./${NAME}

    cat <<CONFIGEOF > "./${PREFIX}/config.rb"
# sandbox specific variables
PROVIDER = "${PROVIDER}"
HOME = "~/"
NAME = "${NAME}"
GITHUB_USERNAME = "${GITHUB_USERNAME}"
GITHUB_EMAIL = "${GITHUB_EMAIL}"
REPO = "${REPO}"
CONFIGEOF

    if [ "$(vagrant box list | grep trusty)" ]
    then
        echo Image trusty exits
    else
        vagrant box add trusty https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
    fi

    # provisioning salt-master
    echo "\n== Provisioning ${PREFIX}salt} =="
    cd ./${NAME}
    vagrant up
    vagrant ssh salt
fi