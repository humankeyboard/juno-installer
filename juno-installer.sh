
#################################################
######## begining of configuration ##############
#################################################


# string to prefix your instances
# so you can identify them easily
NAME="juno"

# github information, so you can push code
GITHUB_USERNAME="username"
GITHUB_EMAIL="e-mail address"


# don't change these
PROVIDER="virtualbox"
VAGRANT_SERVER="localhost"
REPO="https://github.com/humankeyboard/salt-juno.git"

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

    #cp ~/.ssh/id_rsa.pub ./${NAME}/salt-sandbox/configure/files/vagrant.id_rsa.pub

    cat <<CONFIGEOF > "./${NAME}/config.rb"
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
    echo "\n== Provisioning ${NAME} / salt =="
    cd ./${NAME}
    vagrant up
    vagrant ssh orchestration
fi
