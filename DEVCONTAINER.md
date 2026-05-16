# 開発コンテナ設定メモ

このディレクトリには、VS Code Dev Containers などで利用する開発コンテナ設定が `.devcontainer/` 配下に用意されています。

## ファイル構成

- `.devcontainer/devcontainer.json`
  - 開発コンテナ全体の設定ファイルです。
  - 使用する Dockerfile、ワークスペースの場所、マウント設定、コンテナ内ユーザー、環境変数、起動後コマンド、VS Code 拡張機能を定義しています。
- `.devcontainer/Dockerfile`
  - 開発コンテナのイメージを作成するための Dockerfile です。
  - Node.js 22 Bookworm ベースの Dev Container イメージに、開発で使う CLI ツールを追加しています。
- `.devcontainer/postCreateCommand.sh`
  - コンテナ作成後に実行される初期確認スクリプトです。
  - Codex CLI のログイン状態を確認し、未ログインの場合はログインコマンドを表示します。

## devcontainer.json の内容

開発コンテナ名は `codex-dev-ephemeral` です。

コンテナは `.devcontainer/Dockerfile` からビルドされます。

```json
"build": {
  "dockerfile": "Dockerfile"
}
```

ワークスペースはコンテナ内の `/workspace` に配置されます。ローカルのワークスペースフォルダは、コンテナ内の `/workspace` に bind mount されます。

```json
"workspaceFolder": "/workspace",
"mounts": [
  "source=${localWorkspaceFolder},target=/workspace,type=bind"
]
```

コンテナ内では `node` ユーザーとして作業します。

```json
"remoteUser": "node"
```

環境変数として `OPENAI_API_KEY` が定義されています。ただし、初期値は空文字です。

```json
"containerEnv": {
  "OPENAI_API_KEY": ""
}
```

コンテナ作成後には、次のコマンドが実行されます。

```json
"postCreateCommand": "bash .devcontainer/postCreateCommand.sh"
```

VS Code では、以下の拡張機能が推奨インストール対象として指定されています。

- `ms-vscode-remote.remote-containers`
- `esbenp.prettier-vscode`
- `dbaeumer.vscode-eslint`

## Dockerfile の内容

ベースイメージには、Microsoft が提供する Node.js 22 向け Dev Container イメージを使用しています。

```dockerfile
FROM mcr.microsoft.com/devcontainers/javascript-node:1-22-bookworm
```

追加でインストールされる主なツールは以下です。

- `bubblewrap`
- `git`
- `curl`
- `ripgrep`
- `jq`
- `unzip`
- `python3`
- `python3-pip`
- `php-cli`
- `composer`

また、npm のグローバルパッケージとして OpenAI Codex CLI をインストールします。

```dockerfile
RUN npm install -g @openai/codex
```

作業ディレクトリは `/workspace` です。

```dockerfile
WORKDIR /workspace
```

## postCreateCommand.sh の内容

コンテナ作成後、`codex login status` を実行して Codex CLI のログイン状態を確認します。

ログイン済みの場合は次のメッセージを表示します。

```text
Codex already logged in.
```

未ログインの場合は、デバイス認証でログインするためのコマンドを案内します。

```bash
codex login --device-auth
```

## 使い方

VS Code でこのディレクトリを開き、Dev Containers 拡張機能からコンテナで再オープンします。

コンテナ作成後に Codex CLI が未ログインと表示された場合は、ターミナルで以下を実行します。

```bash
codex login --device-auth
```

`OPENAI_API_KEY` を利用する場合は、必要に応じて `devcontainer.json` の `containerEnv` を編集するか、Dev Containers のシークレット管理やホスト側の環境変数連携を利用してください。

## 注意点

- この設定ではローカルワークスペースを `/workspace` に bind mount するため、コンテナ内でのファイル編集はホスト側にも反映されます。
- `OPENAI_API_KEY` は空文字で定義されているため、API キーが必要な処理では別途設定が必要です。
- コンテナ作成後のログイン確認は Codex CLI の状態確認のみで、ログイン操作自体は自動実行されません。
