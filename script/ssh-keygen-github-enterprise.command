#!/bin/sh

GITHUB_ENTERPRISE_DOMAIN='github.hoge.dev'
GITHUB_SETTING_KEYS_URL="https://${GITHUB_ENTERPRISE_DOMAIN}/settings/keys"

# .ssh配下の公開鍵情報をリスト化
key_filepaths=($(ls ${HOME}/.ssh/*.pub))

if [ ${#key_filepaths[@]} -eq 0 ]; then
    # .ssh配下に鍵がなければ作成
    key_filepath="${HOME}/.ssh/id_rsa"
    ssh-keygen -t rsa -b 4096 -f ${key_filepath} -N ""
    echo ''
    echo "=== This SSH key has been copied to the clipboard."
    echo "    'REGISTER' it on Github Enterprise."
    echo "## filepath: ${key_filepath}.pub"
    echo $(<"${key_filepath}.pub")
    echo '==================================================='
    pbcopy < "${key_filepath}.pub"
    open ${GITHUB_SETTING_KEYS_URL}

else
    # 既にgithub enterprise serverにssh鍵が登録されていればその旨を表示する
    echo ''
    echo '=== If it desplayed "successfully authenticated", your SSH key is already registered on GitHub Enterprise.'
    echo $(ssh -T git@${GITHUB_ENTERPRISE_DOMAIN})

    # .ssh配下にid_rsa.pubがあればそれをクリップボードにコピーする
    for key_filepath in ${key_filepaths[@]}; do
        if [ "`echo ${key_filepath} | grep  "id_rsa.pub"`" ]; then
            id_rsa_ssh_key=`cat ${key_filepath}`
            echo ''
            echo "=== This SSH key has been copied to the clipboard."
            echo "    'REGISTER' it on Github Enterprise."
            echo "## filepath: ${key_filepath}"
            echo $(<"${key_filepath}")
            echo '==================================================='
            pbcopy < "${key_filepath}"
            open ${GITHUB_SETTING_KEYS_URL}
            break
        fi
    done

    # id_rsa.pubはなかったが、.ssh配下に鍵がある場合は新たに生成せずに全ての鍵を標準出力する
    if [ -z "${id_rsa_ssh_key}" ]; then
        echo ''
        echo '=== "COPY" any SSH key and "REGISTER" it on Github Enterprise.'
        for key_filepath in ${key_filepaths[@]}; do
            echo "## filepath: ${key_filepath}"
            echo $(<"${key_filepath}")
        done
        echo '==================================================='
        open ${GITHUB_SETTING_KEYS_URL}
    fi
fi
