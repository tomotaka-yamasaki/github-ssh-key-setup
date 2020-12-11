#!/bin/sh

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
else
    # .ssh配下に鍵がある場合は新たに生成せずに全ての鍵を標準出力する
    if [ -z "${registered_ssh_key}" ]; then
        echo ''
        echo '=== "COPY" any SSH key and "REGISTER" it on Github.'
        for key_filepath in ${key_filepaths[@]}; do
            echo "## filepath: ${key_filepath}"
            echo $(<"${key_filepath}")
        done
        echo '==================================================='
    fi
fi
