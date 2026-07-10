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

メインモデルはオーケストレータ。計画・分解・統合・意思決定に温存し、
実作業はサブエージェントへ委譲する。自分のコンテキストは軽く保つ。

- 重い推論（設計・複雑デバッグ・戦略/トレードオフ分析）→ deep-reasoner
- 調査（大量の生データ読み）→ researcher（background）
- 機械的作業（整形・移動・定型生成・単純編集）→ fast-worker
- 読み取り専用のファイル探索・参照引き → scout（background）
- 委譲時は Agent ツールの model パラメータを必ず明示する
  （deep-reasoner=opus / researcher=sonnet / fast-worker=sonnet / scout=haiku）。
  frontmatter の model 指定が無視されるモードがあるため
- 委譲は原則 background で起動し、結果待ちの間もユーザーとの対話を継続する
- fork は「会話文脈の続きが必要な作業」に限定する（fork は親モデルで走り高コスト）
- CLAUDE_CODE_SUBAGENT_MODEL / CLAUDE_CODE_EFFORT_LEVEL 環境変数は使わない
  （エージェント個別設定を全て上書きするため）
- 小さな的確な編集はメインで直接行う（委譲のほうが遅い）。過剰委譲しない
- superpowers 等のスキルが独自にサブエージェントを起動する場合
  （subagent-driven-development / dispatching-parallel-agents / requesting-code-review など）は、
  スキルのプロンプトテンプレートと役割をそのまま使い、こちらからは model 階層だけを明示する
  （機械的実装=sonnet / 統合・判断=sonnet / 設計・レビュー=opus）。
  scout・fast-worker 等の独自ペルソナでスキルのプロンプトを上書きしない
- 実装→レビューのように依存があるフローは、background 既定より
  スキルが定義する制御フロー（逐次/並列）を優先する

