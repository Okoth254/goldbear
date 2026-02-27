---
description: Stage all changes and commit to GitHub
---
Stage all modified files, generate a commit message based on the diff, and push to the remote repository.

// turbo-all
1. Run `git status -s` to see the changed files.
2. Run `git add .` to stage all changes.
3. Ask the user for a commit message if they haven't provided one, or analyze the diff natively using `git diff HEAD` to construct a descriptive commit message. Then use `git commit -m "[message]"`.
4. Run `git push`
