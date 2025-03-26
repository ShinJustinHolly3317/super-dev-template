# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
eval "$(starship init zsh)"

# auto complete
# source ~/tool/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Golang
# export GOROOT=~/.asdf/installs/golang/1.20.7/go
# . ~/.asdf/plugins/golang/set-env.zsh

# asdf 
# export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"   

# vscode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# my functions
chocotoken() {
    curl --header 'Content-Type: application/json' -s \
    --data "{\"accountId\":\"輸入\",\"appId\":\"輸入\",\"licence\":\"editor\",\"scope\":\"write\",\"device\":\"Web\"}" \
    輸入網址 | jq -r '.accessToken'
}

gt() {
    git tag ${1}
}

gtp() {
    git tag ${1} && git push origin ${1}
}

gfReleaseStaging() {
    if read -q "choice?[Danger🌋] Press Y/y to continue with git tag and push and release [${1}]:"; then
        gsw develop && git merge release/${1} --no-ff && gtp ${1}-staging && ggp
    else
        echo
        echo "'$choice' not 'Y' or 'y'. Exiting..."
    fi
}

gfReleaseProd() {
    if read -q "choice?[Danger🌋] Press Y/y to continue with git tag and push and release [${1}]:"; then
        gsw master && git merge release/${1} --no-ff && gtp ${1}-release && ggp
    else
        echo
        echo "'$choice' not 'Y' or 'y'. Exiting..."
    fi
}

replacem3u8() {
    bun /Users/justinkao/LineTV/Scripts/replace-m3u8.js ${1}
}

check_and_start_colima() {
  if pgrep -x "colima" >/dev/null; then
    echo "Colima is already running."
  else
    echo "Colima is not running. Starting it..."
    colima start
  fi
}

createJiraIssue() {
    # Set Jira configuration variables
    local jiraDomain="chocotv.atlassian.net"
    local userEmail="輸入 email"
    local apiToken="輸入 api token"
    local projectKey="SRE"
    local issueType="Task"
    local assigneeId="輸入 account id"
    local projectName=$(git config --get remote.origin.url | sed -E 's/.*\/(.+)\.git/\1/')
    local releaseVer=$(git describe --tags --abbrev=0 | sed 's/-staging$//;s/-release$//')

    # Prepare Authorization header
    local authHeader=$(echo -n "$userEmail:$apiToken" | base64)

    # Read the latest part of CHANGELOG.md into changeLog variable
    local changeLog=$(awk '/^## \[.*\]/ {capture = 1; next} capture && /^\-/ {print; exit}' CHANGELOG.md)

    # Set the issue fields
    local postData=$(cat <<EOF
{
  "fields": {
    "project": {
      "key": "$projectKey"
    },
    "summary": "[Backend] $projectName $releaseVer",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [
            {
              "text": "上版 Release Note 格式範例，並請回答下列問題\\n\\n### Release Note\\n\\n$projectName [$releaseVer-release]\\n\\n$changeLog\\n\\n### 相關問題\\n\\nQ1. 請問本次發版是否有涉及 Database Schema Change，若有 Migration 是否已經完成？\\n\\nAns: \\n\\nQ2. 請問本次發版是否有涉及 Database / Redis 等連線相關改動，若有發版連線相關前置準備是否已經完成？\\n\\nAns: \\n\\nQ3. 請問本次發版 API 是否向後相容？\\n\\nAns:\\n\\nQ4. 希望的發佈時間，以及是否可以立即發布？\\n\\nAns:\\n\\nQ5. 本次發版專案是否有使用到 chocomember-redis, chocomember-middleware 相關 node_modules，Redis 相關環境變數是否已經補上？\\n\\nAns: \\n\\nQ6. 發版不順利的情況下，Rollback 的 Tag 是？\\n\\nAns",
              "type": "text"
            }
          ]
        }
      ]
    },
    "issuetype": {
      "name": "$issueType"
    },
    "assignee": {
      "id": "$assigneeId"
    },
    "parent": {
      "key": "SRE-填入票號"
    }
  }
}
EOF
)

    # Make the API call
    curl -w -s -X POST -H "Authorization: Basic $authHeader" \
         -H "Accept: application/json" \
         -H "Content-Type: application/json" \
         -d "$postData" \
         "https://$jiraDomain/rest/api/3/issue"
}

gitRestart() {
	gsw master && ggl
}

# run single unit test in docker
dockerUnitTest() {
  local modified_path="${1/#taxigo_api/.}"
  docker exec -it api npm run test-single "$modified_path" -- --no-migrate-logs
}

# check_and_start_colima

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# remove all localstack
purgeLocalstackSqs() {
   ~/LINEGO/some-good-scripts/purge-all-sqs
}

# AWS
export AWS_PAGER=""
