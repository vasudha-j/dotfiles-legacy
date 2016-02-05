# Sets up ssh-agent to forward key, supressing the output
ssh-add 2>/dev/null

if [[ -e /usr/local/share/chruby ]]; then
  source '/usr/local/share/chruby/chruby.sh'
  source '/usr/local/share/chruby/auto.sh'
  if [[ -f ~/.ruby-version ]]; then
    chruby $(cat ~/.ruby-version)
  fi
fi

export PATH="$HOME/.bin:$PATH"

# Remove the need for bundle exec ... or ./bin/...
# by adding ./bin to path if the current project is trusted
# Source: http://dance.computer.dance/posts/2015/02/making-chruby-and-binstubs-play-nice.html

function set_local_bin_path() {
  # Replace any existing local bin paths with our new one
  export PATH="${1:-""}`echo "$PATH"|sed -e 's,[^:]*\.git/[^:]*bin:,,g'`"
}

function add_trusted_local_bin_to_path() {
  if [[ -d "$PWD/.git/safe" ]]; then
    # We're in a trusted project directory so update our local bin path
    set_local_bin_path "$PWD/.git/safe/../../bin:"
  fi
}

# Make sure add_trusted_local_bin_to_path runs after chruby so we
# prepend the default chruby gem paths
if [[ -n "$ZSH_VERSION" ]]; then
  if [[ ! "$preexec_functions" == *add_trusted_local_bin_to_path* ]]; then
    preexec_functions+=("add_trusted_local_bin_to_path")
  fi
fi

# Deduplicates PATH (https://github.com/thoughtbot/dotfiles/commit/f074afeae3cd9075c0cca1078bc7dfdaa447bc9f)
export -U PATH
