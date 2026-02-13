# CLAUDE.md

## Project Overview

This is an educational training repository for the **GitHub for Developers** course. It serves as a hands-on companion to GitHub's training on the Wheelhouse platform, where students learn Git and GitHub fundamentals by making changes directly to this repo and receiving feedback.

This is **not** a software project — it contains no code, no build system, no tests, and no CI/CD. It is a collection of markdown instructional documents.

## Repository Structure

```
/
├── README.md                              # Course welcome and goals
├── CLAUDE.md                              # This file
└── instructions/                          # Step-by-step lab guides
    ├── add-file-on-github.md              # Creating files via GitHub web UI
    ├── changing-files-on-GitHub.md         # Editing files on GitHub
    ├── clone-a-repo.md                    # Cloning with GitHub Desktop
    ├── create-issue.md                    # Creating issues, markdown basics
    ├── make-changes-on-desktop.md         # Local editing workflow
    ├── merge-your-pull-request.md         # Merging PRs and closing issues
    ├── new-file-on-desktop.md             # Creating files locally
    └── push-changes-desktop.md            # Pushing changes and opening PRs
```

## Key Details

- **Language:** Markdown only (no code)
- **Primary branch:** `master`
- **Build/test/lint commands:** None — there is no build system, test suite, or linter
- **Dependencies:** None
- **CI/CD:** None configured

## Content Conventions

- All instructional content lives in the `instructions/` directory as markdown files
- Instructions use numbered step-by-step format
- File naming uses lowercase-with-hyphens (e.g., `clone-a-repo.md`)
- Bio files created by students follow the `firstname-lastname.md` naming pattern
- Markdown formatting follows GitHub Flavored Markdown (GFM)
- Commit messages should reference issue numbers where applicable (e.g., `This fixes #3`)

## Workflows Covered by the Training

The repository teaches these GitHub workflows:

1. **Web-based:** Create/edit files on GitHub, commit to branches, open pull requests
2. **Desktop-based:** Clone repos, edit locally, push changes via GitHub Desktop
3. **Collaboration:** Create issues, @mention reviewers, get approvals, merge PRs, delete branches

## Guidelines for AI Assistants

- Changes to this repo should preserve its educational purpose and simple structure
- Keep markdown formatting clean and consistent with existing files
- Do not introduce build tooling, CI/CD, or code — this is a documentation-only repo
- When adding or editing instruction files, maintain the numbered step-by-step format
- Any new instruction files should go in the `instructions/` directory
