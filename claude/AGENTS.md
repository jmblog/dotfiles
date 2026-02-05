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

