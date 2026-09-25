# Linear plugin

This plugin provides command line tools for interacting with [Linear](https://linear.app), the issue tracking tool.

To use it, add `linear` to the plugins array in your zshrc file:

```zsh
plugins=(... linear)
```

The interaction is all done through the web. No local installation or API token is necessary.

In this document, "Linear" refers to the Linear app, and `linear` refers to the command this plugin supplies.

## Usage

This plugin supplies one command, `linear`, through which all its features are exposed. Every form of this command opens a Linear page in your web browser.

## Commands

`linear help` or `linear usage` will print the below usage instructions

| Command                    | Description                                                       |
| :-------------------------- | :----------------------------------------------------------------- |
| `linear`                    | Performs the default action (opens the inbox)                     |
| `linear new [TEAM]`         | Opens a team's page to create a new issue (press `c` to create)   |
| `linear ABC-123`            | Opens an existing issue                                           |
| `linear inbox`              | Opens your Linear inbox                                           |
| `linear mine`               | Opens "My Issues"                                                 |
| `linear team ABC [view]`    | Opens a team's issues (`view`: `active`, `backlog`, `triage`, `all`; default `active`) |
| `linear search <query>`     | Searches Linear for the given query                               |
| `linear branch`             | Opens an existing issue matching the current branch name          |
| `linear dumpconfig`         | Displays the effective configuration                              |
| `linear help`               | Prints usage instructions                                         |

### Linear Branch usage notes

The branch name may have prefixes ending in "/": "feature/MP-1234", and also suffixes
starting with "_": "MP-1234_fix_dashboard". In both these cases, the issue opened will be "MP-1234"

This also checks if the prefix is in the name, and adds it if not, so: "MP-1234" opens the issue "MP-1234",
"mp-1234" opens the issue "mp-1234", and "1234" opens the issue "MP-1234".

If your branch naming convention deviates, you can overwrite the `linear_branch` function to determine and echo the Linear issue key yourself.
Define a function `linear_branch` after sourcing `oh-my-zsh.sh` in your `.zshrc`.
Example:
```zsh
# Determine branch name from naming convention 'type/KEY-123/description'.
function linear_branch() {
  # Get name of the branch
  issue_arg=$(git rev-parse --abbrev-ref HEAD)
  # Strip prefixes like feature/ or bugfix/
  issue_arg=${issue_arg#*/}
  # Strip suffixes like /some-branch-description
  issue_arg=${issue_arg%%/*}
  # Return the value
  echo $issue_arg
}
```

#### Debugging usage

These calling forms are for developers' use, and may change at any time.

```
linear dumpconfig   # displays the effective configuration
```

## Setup

The URL for your Linear workspace is set by `$LINEAR_URL` or a `.linear-url` file, e.g. `https://linear.app/my-workspace`.

Add a `.linear-url` file in the base of your project. You can also set `$LINEAR_URL` in your `~/.zshrc` or put a `.linear-url` in your home directory. A `.linear-url` in the current directory takes precedence, so you can make per-project customizations.

The same goes with `.linear-prefix` and `$LINEAR_PREFIX`. These control the prefix added to issue IDs when a bare issue number is passed (e.g. `linear 123` with prefix `ABC` opens `ABC-123`).

For example:

```
cd to/my/project
echo "https://linear.app/my-workspace" >> .linear-url
```

(Note: The current implementation only looks in the current directory for `.linear-url` and `.linear-prefix`, not up the path, so if you are in a subdirectory of your project, it will fall back to your default Linear URL. This will probably change in the future though.)

### Migrating from the `jira` plugin

If you previously used this plugin's config in `.jira-url` / `~/.jira-url`, it will be used automatically as a fallback if no `.linear-url` / `~/.linear-url` / `$LINEAR_URL` is set. You can move it over to `.linear-url` / `~/.linear-url` whenever convenient; nothing else needs to change.

### Variables

* `$LINEAR_URL` - Your Linear workspace's URL, e.g. `https://linear.app/my-workspace`
* `$LINEAR_PREFIX` - Prefix added to issue ID arguments (e.g. `ABC` so that `linear 123` opens `ABC-123`)
* `$LINEAR_TEAM` - Default team key used by `linear new` and `linear team` when none is given
* `$LINEAR_DEFAULT_ACTION` - Action to do when `linear` is called with no arguments; defaults to "inbox"

### Browser

Your default web browser, as determined by how `open_command` handles `http://` URLs, is used for interacting with Linear. If you change your system's URL handler associations, it will change the browser that `linear` uses.
