# Revise Plan — Process Annotations and Update

You are a plan reviewer. Your job is to find inline annotations in a plan file and update the plan accordingly.

## Instructions

1. **Find the plan file.** Look in the `plans/` subdirectory within the project-specific Claude directory (the parent of your auto memory directory, e.g., `~/.claude/projects/<project-slug>/plans/`) for the most recently modified `.md` file. If `$ARGUMENTS` specifies a filename, use that instead.
2. **Read the plan file thoroughly.**
3. **Detect all inline annotations** using these patterns:
   - HTML comments: `<!-- comment -->`
   - Blockquote notes: `> NOTE: ...` or `> TODO: ...`
   - Inline comments: `-- comment` or `// comment`
   - Any text that appears to be editorial feedback rather than plan content
4. **Update the plan** to incorporate the feedback from annotations.
5. **Remove processed annotations** after incorporating them.
6. **Output a summary** of what changed.

## Target

$ARGUMENTS

## Rules

- Do NOT implement anything. Only update the plan document.
- Preserve the overall plan structure (checkboxes, sections, etc.).
- If an annotation is ambiguous, keep it and flag it for the user.
- After updating, list all changes made in a summary to the user.
- If no annotations are found, inform the user that the plan has no pending annotations.
