# This should be the last thing executed. If it is not, a string of my
# PS1 is printed to the terminal, colorized, with the bash escapes
# (\u@\h ...) intact. Weird, I know!

case ${TERM} in
    [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*)
        _title_hook() {
            local _command
            _command="${BASH_COMMAND//[^[:print:]]/}"
            local _s
            _s='\u@\h \w'
            printf '\e]0;%s (%s)\a' "${_s@P}" "$_command"
        }
        ;;
    screen*)
        _title_hook() {
            local _command
            _command="${BASH_COMMAND//[^[:print:]]/}"
            local _s
            _s='\u@\h \w'
            printf '\ek0%s (%s)\e\\' "${_s@P}" "$_command"
        }
        ;;
    *)
        _title_hook() {
            :
        }
        ;;
esac


trap _title_hook DEBUG
