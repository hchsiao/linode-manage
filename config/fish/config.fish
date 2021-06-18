set -g fish_key_bindings fish_vi_key_bindings

# Sort of enable / for searching command history
# Copied from: https://github.com/fish-shell/fish-shell/issues/2271
function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
  bind -M default / reverse_history_search
end
