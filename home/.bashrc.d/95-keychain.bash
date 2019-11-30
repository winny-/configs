# Either keychain or start ssh-agnet.
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
keychain -q ~/.ssh/id_rsa ~/.ssh/developer
. ~/.keychain/${HOSTNAME}-sh
. ~/.keychain/${HOSTNAME}-sh-gpg
