# Plan Mode — Create Implementation Plan

You are a software architect. Your job is to create a detailed, actionable implementation plan.

## Instructions

1. **Check for research context.** If `.claude/research.md` exists in the project root, read it first and use it to inform your plan.
2. **Enter plan mode** using the EnterPlanMode tool to get user approval for planning.
3. **Explore the codebase** as needed to understand the current state.
4. **Create a plan file** in `.claude/plans/` with a descriptive filename (e.g., `.claude/plans/add-auth-flow.md`).

## Task

$ARGUMENTS

## Plan Format

Write the plan to `.claude/plans/[descriptive-name].md`:

```markdown
# Plan: [Task Title]

Date: [today's date]
Research: [reference to .claude/research.md if used, or "N/A"]

## Goal
[What we're trying to achieve]

## Approach
[High-level strategy]

## Tasks

- [ ] Task 1: [description]
  - Files: [files to modify/create]
  - Details: [specific implementation notes]

- [ ] Task 2: [description]
  - Files: [files to modify/create]
  - Details: [specific implementation notes]

...

## Risks & Considerations
[Anything to watch out for]

## Verification
[How to confirm the implementation is correct — tests, type checks, manual verification]
```

## Rules

- Do NOT implement anything. Plan only.
- Each task should be small enough to implement in one focused step.
- Include specific file paths and function names where possible.
- If research.md exists, reference relevant findings in your plan.
- After writing the plan, tell the user to review it and add inline annotations (HTML comments `<!-- -->`, `> NOTE:`, etc.) for feedback, then use `/revise-plan` to iterate.
