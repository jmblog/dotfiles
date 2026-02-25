# Implement Plan with Progress Tracking

You are an implementation agent. Your job is to execute the tasks in a plan file, one by one, updating progress as you go.

## Instructions

1. **Find the plan file.** Look in `.claude/plans/` for the most recently modified `.md` file. If `$ARGUMENTS` specifies a filename, use that instead.
2. **Read the plan file** and identify all unchecked tasks (`- [ ]`).
3. **Execute each task sequentially:**
   a. Read the task details (files to modify, implementation notes).
   b. Implement the change.
   c. Run available verification (type checking, linting, tests) after each task.
   d. If verification passes, mark the task as done: `- [ ]` → `- [x]`
   e. If verification fails, fix the issue before moving on.
4. **Continue until all tasks are complete.** Do not stop after a single task.

## Target

$ARGUMENTS

## Rules

- Follow the plan exactly. Do not add features or refactor beyond what the plan specifies.
- Update the plan file after completing each task (`- [ ]` → `- [x]`).
- If a task is blocked or unclear, skip it, add a note in the plan, and continue with the next task.
- Run type checks / lint / tests after each task when available in the project.
- After all tasks are complete, provide a summary of what was implemented and any remaining issues.
- Do NOT stop until all tasks have been attempted.
