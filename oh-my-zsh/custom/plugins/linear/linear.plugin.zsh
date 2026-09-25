# CLI support for Linear interaction
#
# See README.md for details

function _linear_usage() {
cat <<EOF
linear                            Performs the default action
linear new [TEAM]                Opens issue creation for a team (press "c" to create)
linear ABC-123                   Opens an existing issue
linear inbox                     Opens your Linear inbox
linear mine                      Opens your assigned issues ("My Issues")
linear team ABC [view]           Opens a team's issues (view: active|backlog|triage|all, default: active)
linear search <query>            Searches Linear for the given query
linear branch                    Opens an existing issue matching the current branch name
linear dumpconfig                Displays effective linear configuration
linear help                      Prints this usage help
EOF
}

# If your branch naming convention deviates, you can partially override this plugin function
# to determine the linear issue key based on your formatting.
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#partially-overriding-an-existing-plugin
function linear_branch() {
  # Get name of the branch
  issue_arg=$(git rev-parse --abbrev-ref HEAD)
  # Strip prefixes like feature/ or bugfix/
  issue_arg=${issue_arg##*/}
  # Strip suffixes starting with _
  issue_arg=(${(s:_:)issue_arg})
  # If there is only one part, it means that there is a different delimiter. Try with -
  if [[ ${#issue_arg[@]} = 1 && ${issue_arg} == *-* ]]; then
    issue_arg=(${(s:-:)issue_arg})
    issue_arg="${issue_arg[1]}-${issue_arg[2]}"
  else
    issue_arg=${issue_arg[1]}
  fi
  if [[ "${issue_arg:l}" = ${linear_prefix:l}* ]]; then
    echo "${issue_arg}"
  else
    echo "${linear_prefix}${issue_arg}"
  fi
}

function linear() {
  emulate -L zsh
  local action linear_url linear_prefix
  if [[ -n "$1" ]]; then
    action=$1
  elif [[ -f .linear-default-action ]]; then
    action=$(cat .linear-default-action)
  elif [[ -f ~/.linear-default-action ]]; then
    action=$(cat ~/.linear-default-action)
  elif [[ -n "${LINEAR_DEFAULT_ACTION}" ]]; then
    action=${LINEAR_DEFAULT_ACTION}
  else
    action="inbox"
  fi

  if [[ -f .linear-url ]]; then
    linear_url=$(cat .linear-url)
  elif [[ -f ~/.linear-url ]]; then
    linear_url=$(cat ~/.linear-url)
  elif [[ -n "${LINEAR_URL}" ]]; then
    linear_url=${LINEAR_URL}
  elif [[ -f .jira-url ]]; then
    # Fallback for setups migrating from the jira plugin
    linear_url=$(cat .jira-url)
  elif [[ -f ~/.jira-url ]]; then
    linear_url=$(cat ~/.jira-url)
  else
    _linear_url_help
    return 1
  fi
  # Strip trailing slash, if any
  linear_url=${linear_url%/}

  if [[ -f .linear-prefix ]]; then
    linear_prefix=$(cat .linear-prefix)
  elif [[ -f ~/.linear-prefix ]]; then
    linear_prefix=$(cat ~/.linear-prefix)
  elif [[ -n "${LINEAR_PREFIX}" ]]; then
    linear_prefix=${LINEAR_PREFIX}
  else
    linear_prefix=""
  fi

  if [[ $action == "new" ]]; then
    local team=${2:-$LINEAR_TEAM}
    if [[ -n "$team" ]]; then
      echo "Opening ${team} to create a new issue (press \"c\")"
      open_command "${linear_url}/team/${(U)team}/active"
    else
      echo "Opening Linear to create a new issue (press \"c\")"
      open_command "${linear_url}"
    fi
  elif [[ "$action" == "help" || "$action" == "usage" ]]; then
    _linear_usage
  elif [[ "$action" == "inbox" ]]; then
    echo "Opening inbox"
    open_command "${linear_url}/inbox"
  elif [[ "$action" == "mine" ]]; then
    echo "Opening my issues"
    open_command "${linear_url}/my-issues"
  elif [[ "$action" == "team" ]]; then
    local team=${2:-$LINEAR_TEAM}
    local view=${3:-active}
    if [[ -z "$team" ]]; then
      echo "error: no team specified and \$LINEAR_TEAM is not set" >&2
      return 1
    fi
    echo "Opening team ${(U)team} (${view})"
    open_command "${linear_url}/team/${(U)team}/${view}"
  elif [[ "$action" == "search" ]]; then
    shift
    local query="${*}"
    if [[ -z "$query" ]]; then
      echo "Opening search"
      open_command "${linear_url}/search"
    else
      echo "Searching for: ${query}"
      open_command "${linear_url}/search?q=${(j:+:)${(s: :)query}}"
    fi
  elif [[ "$action" == "dumpconfig" ]]; then
    echo "LINEAR_URL=$linear_url"
    echo "LINEAR_PREFIX=$linear_prefix"
    echo "LINEAR_TEAM=$LINEAR_TEAM"
    echo "LINEAR_DEFAULT_ACTION=$LINEAR_DEFAULT_ACTION"
  else
    # Anything that doesn't match a special action is considered an issue name
    # but `branch` is a special case that will parse the current git branch
    local issue_arg issue
    if [[ "$action" == "branch" ]]; then
      issue=$(linear_branch)
    else
      issue_arg=${(U)action}
      issue="${linear_prefix}${issue_arg}"
    fi

    echo "Opening issue #$issue"
    open_command "${linear_url}/issue/${issue}"
  fi
}

function _linear_url_help() {
  cat << EOF
error: Linear URL is not specified anywhere.

Valid options, in order of precedence:
  .linear-url file
  \$HOME/.linear-url file
  \$LINEAR_URL environment variable
  .jira-url / \$HOME/.jira-url file (legacy fallback)

The URL is your Linear workspace URL, e.g. https://linear.app/my-workspace
EOF
}
