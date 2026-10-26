# CLAUDE.md

## Execution Efficiency

- **Parallel execution**: When multiple independent processes are needed, invoke tools concurrently, not sequentially
- **Language protocol**: Think exclusively in English, respond in Japanese

## Information Discovery

- When you need project-specific context, check for `CLAUDE.md` or `README.md` in the repository root
- When uncertain about implementation approaches, explore the codebase first using Glob/Grep/Read tools
- When facing architectural decisions, use the Task tool with subagent_type=Explore for thorough analysis

## UI Development

When working with internationalized UI text, be aware that Japanese uses full-width parentheses （） instead of regular parentheses (). Always check for both when searching or modifying text labels.

## GitHub Operations

- **PR comment retrieval**: Always use `gh` command via Bash tool to view GitHub PR comments
  - Example: `gh pr view <PR_NUMBER> --comments`
  - Example: `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments`
- **Never use WebSearch**: For any GitHub-related operations (PRs, issues, comments, checks), always use `gh` command instead of WebSearch

## File Operations

- **Path quoting for special characters**: ALWAYS quote file paths containing parentheses "()" or other special shell characters
  - **Critical for Bash tool**: Shell interprets parentheses as glob patterns, causing "no matches found" errors
  - **Git commands**: `git add "src/app/(dpc)/file.tsx"` NOT `git add src/app/(dpc)/file.tsx`
  - **Shell commands**: `cd "path/(with)/parens"`, `cat "file(1).txt"`
  - **File tools**: Read, Edit, Write tools automatically handle paths, but verify special characters in path parameters
  - **Common error**: `(eval):1: no matches found:` indicates missing quotes around path with special characters

## Orchestration（モデル使い分け）

メインセッションがサブエージェントに作業を渡すときの基準。サブエージェントとして起動されたときは、渡された作業を自分で実行する。

既定はメインで自分で進める。サブエージェントは起動のたびに文脈を作り直して探索し直し、メインはその報告を読み直すので、時間もトークンも余分にかかる。
委譲するのは、それを上回る見返りがあるときだけ:
- 大量の生データ（ログ、長いスレッド、多数の資料の突き合わせ）を読んで結論と出典だけ欲しいとき → researcher（background）。メインの文脈を膨らませず、安いモデルで読める
- 互いに独立した大きめの作業を並列に回したいとき
- 会話の経緯から切り離して深く考えさせたいとき（設計・複雑デバッグ・戦略/トレードオフ分析）→ deep-reasoner。deep-reasoner も Opus なので、メインが Opus のときの違いは effort と新しい文脈だけ。会話の経緯はブリーフに書いた分しか届かない

数回のツール呼び出しで終わる作業（数行の確認、数ファイルの読み、単純な検索、小さな的確な編集、ファイル数個の移動）はメインで直接行う。

委譲するときの割り当て:
- 機械的作業（整形・移動・定型生成・単純編集）→ fast-worker
  - まとまった量の、結果を機械的に確かめられる作業（多数ファイルの移動・アーカイブ・リネーム、決まった文字列の一括置換、スクリプトの実行）は model=haiku（Haiku 5.5）
  - 日本語の定型文書の生成（作業ログ・PROJECT.md の行など）と、ほかのセッションも編集するファイルの部分編集は model=sonnet（Sonnet 5.5）
- 読み取り専用の広いファイル探索 → scout（background）
- 委譲時は Agent ツールの model パラメータを必ず明示する
  （deep-reasoner=opus / researcher=sonnet / fast-worker=haiku または sonnet（上の区分で選ぶ） / scout=haiku）。
  frontmatter の model 指定が無視されるモードがあるため
- ブリーフは最初の一回で過不足なく書く。委譲したら、同じ調べ直しをメインでしない
- 委譲は原則 background で起動し、結果待ちの間もユーザーとの対話を継続する
- fork は「会話文脈の続きが必要な作業」に限定する（fork は親モデルで走り高コスト）
- CLAUDE_CODE_SUBAGENT_MODEL / CLAUDE_CODE_EFFORT_LEVEL 環境変数は使わない
  （エージェント個別設定を全て上書きするため）
- superpowers 等のスキルが独自にサブエージェントを起動する場合
  （subagent-driven-development / dispatching-parallel-agents / requesting-code-review など）は、
  スキルのプロンプトテンプレートと役割をそのまま使い、こちらからは model 階層だけを明示する
  （機械的実装=sonnet / 統合・判断=sonnet / 設計・レビュー=opus）。
  scout・fast-worker 等の独自ペルソナでスキルのプロンプトを上書きしない
- 実装→レビューのように依存があるフローは、background 既定より
  スキルが定義する制御フロー（逐次/並列）を優先する

