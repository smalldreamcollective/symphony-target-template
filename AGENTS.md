# Agent Conventions

This file is read by AI coding agents at the start of every session.
It defines the coding standards and conventions for this project.

## Before You Start

1. Read this file in full.
2. Check for an existing open PR for your branch — if one exists, read its review comments before making changes.
3. Explore the codebase with `bash` before modifying anything.

## Git

- Run `git status` before staging anything. Verify what you are about to commit.
- Never commit build artifacts: `node_modules/`, `dist/`, `build/`, `.next/`, `.cache/`, `*.pyc`, `__pycache__/`
- Never commit secrets: `.env`, `.env.local`, credentials, API keys
- Never commit editor or OS files: `.DS_Store`, `.idea/`, `.vscode/`
- Use `git add <specific-files>` rather than `git add -A` unless you have verified every file in `git status`
- Write concise, descriptive commit messages

## Code

- Read existing files to understand the project's style before writing new code
- Follow the conventions already present (indentation, naming, structure)
- Run the test suite before committing if one exists
- Do not introduce new dependencies without a clear reason

## Pull Requests

- Title format: `<issue-identifier>: <short description>`
- PR body should explain what changed and why, not just what the issue said
- Link the issue in the PR body with `Closes <issue-identifier>`

## What Not To Do

- Do not mark an issue done without having made and committed code changes
- Do not commit if tests are failing
- Do not ask for clarification — use your best judgement and note assumptions in the PR
