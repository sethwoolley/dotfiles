DOTFILES_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )
: "${PLAIN_OUTPUT:=}"
ARCH=$(uname -a | grep -Eo '(x86_64|arm64)' | head -n1)
FORCE=${FORCE:-}


COLOUR_BANNER='\e[38;5;228m'
COLOUR_RESET='\e[0m'
COLOUR_MSG='\e[34m'
COLOUR_OK='\e[32m'
COLOUR_WARN='\e[33m'
COLOUR_ERROR='\e[31m'

msg() {
    local message="$1"
    if [ -n "$PLAIN_OUTPUT" ]; then
        echo "$message"
        return
    fi
    echo -e "${COLOUR_MSG}- $message${COLOUR_RESET}"
}

ok() {
    local message="$1"
    if [ -n "$PLAIN_OUTPUT" ]; then
        echo "$message"
        return
    fi
    echo -e "${COLOUR_OK}✓ $message${COLOUR_RESET}"
}

warn() {
    local message="$1"
    if [ -n "$PLAIN_OUTPUT" ]; then
        echo "WARNING: $message" >&2
        return
    fi
    echo -e "${COLOUR_WARN}! $message${COLOUR_RESET}" >&2
}

error() {
    local message="$1"
    if [ -n "$PLAIN_OUTPUT" ]; then
        echo "ERROR: $message" >&2
        return
    fi
    echo -e "${COLOUR_ERROR}✗ $message${COLOUR_RESET}" >&2
}

banner () {
    local message="$1"
    if [ -n "$PLAIN_OUTPUT" ]; then
        echo "BANNER: $message"
        return
    fi
    # banner with yellow (i like yellow)
    echo -e ""
    echo -e "${COLOUR_BANNER}============= $1 =============${COLOUR_RESET}"
    echo -e ""
}


run() {
  local cmd="$*"
  local tmp
  tmp="$(mktemp -t run_with_spinner.XXXXXX)" || tmp="/tmp/run_with_spinner.$$"

  # Start the command in background, capture both stdout and stderr
  bash -c "$cmd" >"$tmp" 2>&1 &
  local pid=$!

  # Ensure we clean up on interrupt
  trap "kill $pid 2>/dev/null; rm -f \"$tmp\"; tput cnorm 2>/dev/null; exit 130" INT TERM

  if [ -n "$PLAIN_OUTPUT" ]; then
    # If not fancy, just wait and print output at the end
    wait "$pid"
    local rc=$?
    cat "$tmp"
    rm -f "$tmp"
    return $rc
  fi

  # Spinner chars
  local spin=('⠇' '⠋' '⠙' '⠸' '⠴' '⠦')
  local frames=6
  local i=0

  # Hide cursor if possible
  tput civis 2>/dev/null || true

  # print spinner then command the whole time
  while kill -0 "$pid" 2>/dev/null; do
    printf "%s %s" "${spin[i]}" "$cmd"
    sleep 0.12
    printf "\r\033[2K"
    ((i=(i+1)%$frames))
  done

  wait "$pid"
  local rc=$?

  # clear spinner line
  printf "\r\033[2K"

  # Restore cursor
  tput cnorm 2>/dev/null || true

  if [ $rc -eq 0 ]; then
    # Success: ok and command
    ok "$cmd"
    rm -f "$tmp"
    return 0
  else
    # Failure: error and exit code, dump output in red
    error "$cmd (exit $rc)"
    printf "\e[31m" >&2
    cat "$tmp" >&2
    printf "\e[0m" >&2
    rm -f "$tmp"
    return $rc
  fi
}

ln_safe() {
    # redirect $1 to $2
    local src="$1"
    local dst="$2"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ -L "$dst" ] && [ "$(readlink "$dst")" == "$src" ]; then
            msg "Using existing symlink $src"
            return 0
        fi
    fi

    run ln -s "$src" "$dst"
}
