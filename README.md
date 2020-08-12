# github-ssh-key-setup
Register SSH key to Github

## Contents
### install-git-gitlfs.command
- 以下のインストールを自動で行うためのスクリプト
  - Homebrew
  - git
  - git-lfs

### ssh-keygen-github.command
- GitHubにSSH公開鍵を登録するためのスクリプト
  - .ssh配下に公開鍵ファイルがなければ生成
  - 存在し、かつGitHubに既に登録済みであれば何もしない
  - 未登録であればクリップボードにコピーし、登録画面を開く

### ssh-keygen-github-enterprise.command
- GitHub Enterprise ServerにSSH公開鍵を登録するためのスクリプト
  - .ssh配下に公開鍵ファイルがなければ生成
  - GitHub Enterprise Serverとssh接続可能か確認
    - SSO対応済みなのでGitHubのようにcurlを使い、 'username'.keys で鍵取得できない
  - .ssh配下にid_rsa.pubがあればクリップボードにコピーし、登録画面を開く
  - .ssh配下に他の方式の鍵がある場合は標準出力し、登録画面を開く

## Usage
- *.command ファイルをダブルクリックし実行する
  - 開発元不明の許可を求められるので 右クリック > 開く がおすすめ
- ssh-keygen-github-enterprise.command は実行前に GITHUB_ENTERPRISE_DOMAIN を設定すること
