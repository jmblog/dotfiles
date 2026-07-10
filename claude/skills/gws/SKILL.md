---
name: gws
description: "Google Drive/Docs/Sheetsをgws CLIで検索・取得。gcloud ADCトークンを使ってリアルタイムにWorkspaceデータにアクセス。トリガー: /gws, google drive検索, driveから取得, ドライブ検索"
---

# /gws - Google Workspace CLI

## 概要
gws CLI（Google Workspace CLI）を使って、組織のGoogle Drive/Docs/Sheets にリアルタイムでアクセスするスキル。カスタムOAuthクライアントID + gcloud ADCトークンを利用する。

## 使い方
```
/gws ドライブで「議事録」を検索して
/gws <Google DocsのURL> の内容を取得して
/gws <SpreadsheetのURL> のシート一覧を見せて
```

## ARGUMENTS の解釈
- 検索キーワード → Drive files list で検索
- Google Docs/Sheets URL → ファイルIDを抽出してexport/get
- 特定の指示 → 取得後に処理

---

## このスキルがやること

### ステップ1: トークン取得とgwsコマンド実行

**重要**: 
- `print-access-token` の結果（`ya29.`で始まるトークン）をそのままAIに表示しないこと
- サンドボックス環境では `$(gcloud ... 2>/dev/null)` でトークンが空になるバグがあるため、**必ずファイル経由**でトークンを渡す
- **`GOOGLE_WORKSPACE_PROJECT_ID`** を指定しないと403エラーになる

```bash
# ステップ1a: トークンをファイルに保存
gcloud auth application-default print-access-token > /private/tmp/claude-501/gws_token.txt 2>/dev/null

# ステップ1b: ファイルからトークンを読み込んでgwsを実行
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files list --params '{"q": "name contains '\''検索ワード'\''", "pageSize": 10}' --format table
```

### ステップ2: ファイル内容の取得

Google Docsの内容をプレーンテキストで取得:
```bash
gcloud auth application-default print-access-token > /private/tmp/claude-501/gws_token.txt 2>/dev/null

GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files export --params '{"fileId": "<FILE_ID>", "mimeType": "text/plain"}' -o /private/tmp/claude-501/gdoc_export.txt
```

Google Sheetsの値を取得:
```bash
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws sheets spreadsheets.values get --spreadsheet-id <SPREADSHEET_ID> --range "Sheet1" --format table
```

### URLからファイルIDを抽出する方法
- Google Docs: `https://docs.google.com/document/d/{FILE_ID}/edit` → `{FILE_ID}` 部分
- Google Sheets: `https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit` → `{SPREADSHEET_ID}` 部分
- Google Drive: `https://drive.google.com/file/d/{FILE_ID}/view` → `{FILE_ID}` 部分

---

## Shared Drive（共有ドライブ）のファイルにアクセスする

デフォルトでは「マイドライブ」のみ検索される。Shared Driveのファイルにアクセスするには、以下のパラメータを追加する:

### 検索時
```bash
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files list --params '{
    "q": "name contains '\''検索ワード'\''",
    "pageSize": 10,
    "includeItemsFromAllDrives": true,
    "supportsAllDrives": true,
    "corpora": "allDrives"
  }' --format table
```

### ファイル取得・エクスポート時
```bash
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files get --params '{"fileId": "<FILE_ID>", "supportsAllDrives": true, "fields": "id,name,mimeType,webViewLink,modifiedTime"}'
```

### スプレッドシートをCSVでエクスポート
```bash
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files export --params '{"fileId": "<FILE_ID>", "mimeType": "text/csv"}' -o /private/tmp/claude-501/output.csv
```

---

## よく使うコマンド

### ファイル検索
```bash
# キーワード検索
--params '{"q": "name contains '\''キーワード'\''", "pageSize": 10}'

# フォルダ内検索
--params '{"q": "'\''FOLDER_ID'\'' in parents", "pageSize": 20}'

# MIMEタイプで絞り込み
--params '{"q": "mimeType = '\''application/vnd.google-apps.document'\''", "pageSize": 10}'

# 複合検索
--params '{"q": "name contains '\''議事録'\'' and mimeType = '\''application/vnd.google-apps.document'\''", "pageSize": 10}'

# Shared Drive含む全ドライブ検索
--params '{"q": "name contains '\''キーワード'\''", "pageSize": 10, "includeItemsFromAllDrives": true, "supportsAllDrives": true, "corpora": "allDrives"}'
```

### ファイル情報取得
```bash
gws drive files get --params '{"fileId": "<FILE_ID>", "supportsAllDrives": true, "fields": "id,name,mimeType,webViewLink,modifiedTime"}'
```

### gws CLIのオプション
| オプション | 説明 |
|-----------|------|
| `--params '<JSON>'` | APIのクエリパラメータをJSON形式で指定 |
| `--format table` | テーブル形式で出力 |
| `--format csv` | CSV形式で出力 |
| `--format yaml` | YAML形式で出力 |
| `--page-all` | 全ページを自動取得（NDJSON） |
| `-o <PATH>` | 出力先ファイル指定（バイナリレスポンス用） |

---

## 初期セットアップ（未設定の場合）

ユーザーが初めて使う場合は、以下の手順を案内する:

### 1. gws CLIのインストール

**macOS (Apple Silicon)**
```bash
curl -sL https://github.com/googleworkspace/cli/releases/download/v0.11.1/gws-aarch64-apple-darwin.tar.gz | tar xz -C /tmp
sudo cp /tmp/gws-aarch64-apple-darwin/gws /usr/local/bin/gws
```

**macOS (Intel)**
```bash
curl -sL https://github.com/googleworkspace/cli/releases/download/v0.11.1/gws-x86_64-apple-darwin.tar.gz | tar xz -C /tmp
sudo cp /tmp/gws-x86_64-apple-darwin/gws /usr/local/bin/gws
```

**Windows (PowerShell)**
```powershell
Invoke-WebRequest -Uri "https://github.com/googleworkspace/cli/releases/download/v0.11.1/gws-x86_64-pc-windows-msvc.zip" -OutFile "$env:TEMP\gws.zip"
Expand-Archive -Path "$env:TEMP\gws.zip" -DestinationPath "$env:LOCALAPPDATA\gws" -Force
# PATHに追加（永続化する場合はシステム環境変数に追加してください）
$env:PATH += ";$env:LOCALAPPDATA\gws"
```

### 2. Google認証（カスタムOAuthクライアントID使用）

**重要: gcloud最新版ではデフォルトのクライアントIDがブロックされるため、カスタムOAuthクライアントIDが必須。**

OAuthクライアントIDのJSONファイルはこのスキルと同じディレクトリにある:
`~/.claude/skills/gws/oauth-client.json`

```bash
gcloud auth application-default login \
  --client-id-file=~/.claude/skills/gws/oauth-client.json \
  --scopes=https://www.googleapis.com/auth/drive.readonly,https://www.googleapis.com/auth/cloud-platform
```

認証完了後にWARNINGが出ても、`Credentials saved to file:` の行が出ていれば問題ない。

### 3. quota projectの設定

Drive APIにはquota project（API使用量をカウントするプロジェクト）の指定が必須。`gcloud auth application-default set-quota-project` はスコープ不足で失敗するため、ADCのJSONファイルに直接書き込む:

**注意: CC（Claude Code）のサンドボックス内ではADCファイルの書き込みが制限される場合がある。その場合はユーザーのターミナルで直接実行すること。**

```bash
python3 -c "
import json, os
f = os.path.expanduser('~/.config/gcloud/application_default_credentials.json')
d = json.load(open(f))
d['quota_project_id'] = 'ubie-local-svc'
json.dump(d, open(f, 'w'), indent=2)
print('Done: quota_project_id set to ubie-local-svc')
"
```

### 4. 動作確認
```bash
gcloud auth application-default print-access-token > /private/tmp/claude-501/gws_token.txt 2>/dev/null
GOOGLE_WORKSPACE_CLI_TOKEN=$(cat /private/tmp/claude-501/gws_token.txt | tr -d '\n\r') \
GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc \
  gws drive files list --params '{"pageSize": 3}' --format table
```

---

## トラブルシューティング

### 「このアプリはブロックされます」
- **原因**: gcloud最新版でデフォルトのクライアントIDが使えなくなった、または複数スコープをリクエストした
- **対処**: `--client-id-file=~/.claude/skills/gws/oauth-client.json` を付けて認証する（上記 Step 2 参照）

### `--scopes` なしだと `cloud-platform` 必須エラー
```
ERROR: Invalid value for [--scopes]: cloud-platform scope is required but not requested.
```
- **原因**: gcloud最新版で `cloud-platform` スコープが必須化された
- **対処**: `--scopes=https://www.googleapis.com/auth/drive.readonly,https://www.googleapis.com/auth/cloud-platform` のように両方指定し、`--client-id-file` も付ける

### 403: quota project not set
```
"reason": "accessNotConfigured"
```
- **原因**: Drive APIのquota projectが設定されていない
- **対処**: 上記「3. quota projectの設定」を実行。またはコマンド実行時に `GOOGLE_WORKSPACE_PROJECT_ID=ubie-local-svc` を環境変数で渡す

### ERROR: User does not have permission to access projects instance
- **原因**: `gcloud auth application-default set-quota-project` 実行時のスコープ不足
- **状況**: 認証自体は成功している（`Credentials saved to file:` が出ていれば）
- **対処**: このエラーは無視してOK。python3でADCファイルに直接 `quota_project_id` を書き込む

### ADCファイルへの書き込みが PermissionError になる
```
PermissionError: [Errno 1] Operation not permitted: '~/.config/gcloud/application_default_credentials.json'
```
- **原因**: Claude Codeのサンドボックスが `~/.config/gcloud/` への書き込みをブロックしている
- **対処**: ユーザーのターミナル（iTerm等）で直接python3コマンドを実行する

### Shared Driveのファイルが404になる / 検索で出てこない
- **原因**: デフォルトでは「マイドライブ」のみが対象
- **対処**: パラメータに以下を追加:
  ```json
  "includeItemsFromAllDrives": true, "supportsAllDrives": true, "corpora": "allDrives"
  ```

### gws: command not found
- **対処**: 上記「1. gws CLIのインストール」を実行

### gws drive files list で空の結果
- **原因**: 検索クエリの構文エラー、またはスコープ不足
- **対処**: `--params` のJSON形式を確認。シングルクォートのエスケープに注意

### `gcloud auth application-default login` をやり直した場合
- **注意**: ADCファイルが上書きされ `quota_project_id` が消える
- **対処**: Step 3 のpython3コマンドだけ再実行すればOK

---

## セキュリティ注意事項
- `print-access-token` の結果（`ya29.` で始まるトークン）をユーザーに直接表示しない
- トークンは環境変数 `GOOGLE_WORKSPACE_CLI_TOKEN` 経由で渡し、コマンド出力には含めない
- 取得したドキュメント内容は社内情報を含むため、外部サービスに送信しない
- `oauth-client.json` はOAuthのデスクトップアプリ用クライアントID（public client）であり、これ単体で認証はできないため、スキルディレクトリに配置してOK

## 関連スキル
- `/google-docs`: Dev Genius経由でGoogle Docsを取得（LLM処理付き）
- `/notion`: Notionページ読み込み
