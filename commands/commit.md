---
description: Generate a commit message from staged changes and commit
subtask: true
---

First, run `git diff --cached` to see what is staged. Then run `git diff --cached --stat` to see the file summary.

Based on the staged changes, write a well-formed git commit message following these rules:

1. **Subject line**: 50-72 chars, imperative mood ("add feature" not "added feature"), no period at end. check previous commit messages and align with the existing wording style
2. **Blank line** after subject
3. **Body**: wrapped at 72 chars, explaining *what* changed and *why* (not how). Include relevant context, motivation, and any important details

Use the format:

```
subject line

body paragraph(s)
```

Then invoke:

```
git commit -m "subject line" -m "body text"
```

Do NOT stage any files — the user has already staged what they want.
Do NOT push.
