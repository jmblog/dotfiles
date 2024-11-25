HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Ignore some commands
HISTORY_IGNORE="(ls|ll|pwd|exit)"

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# 古いコマンドと同じものは無視
setopt hist_save_no_dups

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開
setopt hist_expand

# 履歴を追加
setopt append_history

# 複数シェル間で履歴を共有
setopt share_history

# 履歴をインクリメンタルに追加
setopt inc_append_history
