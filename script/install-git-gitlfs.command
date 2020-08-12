#! /bin/sh

xcode-select --install

brew_version=$(brew -v)
echo ${brew_version}
if [ -z "${brew_version}" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    if [ -z "`echo $PATH | grep '/usr/local/bin'`" ]; then
        echo export PATH='/usr/local/bin:$PATH' >> "${HOME}/.bash_profile"
        source ~/.bash_profile
    fi
fi

brew install git git-lfs
brew upgrade git git-lfs
git lfs install
git version
git lfs version
