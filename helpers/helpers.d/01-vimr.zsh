
if ! command -v vimr; then
    echo 'vimr not installed' >&2
    return 1
fi

alias vimr='vimr --cur-env'
alias vim='vimr'
