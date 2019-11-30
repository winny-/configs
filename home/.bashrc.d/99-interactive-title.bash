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
            echo -en "\e]0;${_s@P} ($_command)\a"
        }
	;;
    screen*)
        _title_hook() {
            local _command
            _command="${BASH_COMMAND//[^[:print:]]/}"
            local _s
            _s='\u@\h \w'
            echo -en "\ek0${_s@P} ($_command)\e"
        }
	;;
    *)
        _title_hook() {
            :
        }
	;;
esac


trap _title_hook DEBUG
