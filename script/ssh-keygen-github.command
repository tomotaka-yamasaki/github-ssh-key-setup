#!/bin/sh

GITHUB_SETTING_KEYS_URL='https://github.com/settings/keys'

# .ssh配下の公開鍵情報をリスト化
key_filepaths=($(ls ${HOME}/.ssh/*.pub))
for key_filepath in ${key_filepaths[@]}; do
    pub_key=$(<"${key_filepath}")
    pub_key=$(echo "${pub_key}" | sed -e "s/^.* \([[:alnum:][:punct:]]*\) .*$/\1/")
    pub_keys+=("${pub_key}")
done

if [ ${#pub_keys[@]} -eq 0 ]; then
    # .ssh配下に鍵がなければ作成
    key_filepath="${HOME}/.ssh/id_rsa"
    ssh-keygen -t rsa -b 4096 -f ${key_filepath} -N ""
    echo ''
    echo "=== This SSH key has been copied to the clipboard."
    echo "    'REGISTER' it on Github."
    echo "## filepath: ${key_filepath}.pub"
    echo $(<"${key_filepath}.pub")
    echo '====================================='
    pbcopy < "${key_filepath}.pub"
    open ${GITHUB_SETTING_KEYS_URL}

else
    # .ssh配下に鍵があればGitHubに登録された鍵と照合する
    read -p 'GitHub Username: ' github_username
    ssh_keys=$(curl "https://github.com/${github_username}.keys")

    echo '=== These SSH keys registered on GitHub.'
    echo ${ssh_keys[@]}
    echo '====================================='

    # .ssh配下の鍵を順番に照合する
    i=0
    registered_ssh_key=''
    for pub_key in ${pub_keys[@]}; do
        # 登録済みの鍵があれば標準出力する
        if [ "`echo "${ssh_keys}" | grep "${pub_key}"`" ]; then
            registered_ssh_key=`cat ${key_filepaths[$i]}`

            echo $(ssh -T git@github.com)
            echo ''
            echo '=== This SSH key is already registered on GitHub.'
            echo "## filepath: ${key_filepaths[$i]}"
            echo ${registered_ssh_key}
            echo '================================================='
        fi
        i=$i+1
    done

    # 登録済みの鍵はなかったが.ssh配下に鍵がある場合は新たに生成せずに全ての鍵を標準出力する
    if [ -z "${registered_ssh_key}" ]; then
        echo ''
        echo '=== "COPY" any SSH key and "REGISTER" it on Github.'
        for key_filepath in ${key_filepaths[@]}; do
            echo "## filepath: ${key_filepath}"
            echo $(<"${key_filepath}")
        done
        echo '==================================================='
        open ${GITHUB_SETTING_KEYS_URL}
    fi
fi
