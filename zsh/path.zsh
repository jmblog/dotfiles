# PATH settings

path=(
  $HOME/bin
  /usr/local/{bin,sbin}
  /usr/local/opt/{coreutils/libexec/gnubin,openssl/bin,openjdk@11/bin}
  /usr/local/go/bin
  $(go env GOPATH)/bin
  $HOME/.volta/bin
  $path
)

export PATH
