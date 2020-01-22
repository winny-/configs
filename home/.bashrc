# This bashrc was originally based off gentoo's. Then I added sensible
# bash. Then I saw a blog post recommending splitting .bashrc into
# different files in the from of .bashrc.d and I'm inclined to think
# that's a great idea, given how ridiculously busy shell startup files
# get.

###################################################
# This should be the first thing ran in the bashrc
###################################################


if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

##################################################


##################################################
# Stuff I haven't sorted yet
##################################################

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Save each command to the history file as it's executed.  #517342
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
#PROMPT_COMMAND='history -a'

##################################################


##################################################
# Source the numerically prefixed startup files in
# .bashrc.d/
##################################################

# Uncomment to trace
#set -x

for i in ~/.bashrc.d/[0-9]*; do
    . "$i"
done
unset i

##################################################
