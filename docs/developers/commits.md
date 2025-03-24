# Commits

Commits sollten die [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) Spezifikation befolgen.

## Exzerpt

The Conventional Commits specification is a lightweight convention on top of commit messages.
It provides an easy set of rules for creating an explicit commit history,
which makes it easier to write automated tools on top of.
This convention dovetails with SemVer by describing the features, fixes, and breaking changes made in commit messages.

The commit message should be structured as follows:

`<type>[optional scope]: <description>`

The commit contains the following structural elements to communicate intent to the consumers of your library:

`fix: a commit of the type fix patches a bug in your codebase`

(this correlates with PATCH in Semantic Versioning).

`feat: a commit of the type feat introduces a new feature to the codebase`

(this correlates with MINOR in Semantic Versioning).

## Examples

Commit message with description

`feat: allow provided config object to extend other configs`

`docs: correct spelling of CHANGELOG`

Commit message with scope

`feat(lang): add Polish language`

## CommitCheck Bot

RegEx Filter: `^(feat|fix|chore|docs|style|refactor|perf|test|build|ci|revert)(\([^\)]+\))?(\!)?\: .+`
