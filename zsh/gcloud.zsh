# Google Cloud SDK configuration with lazy loading

_init_gcloud_sdk() {
  unset -f gcloud bq gsutil _init_gcloud_sdk
  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
}

gcloud() { _init_gcloud_sdk && command gcloud "$@"; }
bq() { _init_gcloud_sdk && command bq "$@"; }
gsutil() { _init_gcloud_sdk && command gsutil "$@"; }
