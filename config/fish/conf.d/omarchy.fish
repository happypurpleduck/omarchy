# Omarchy fish additions — sourced after cachyos-fish-config (append-only).

if not contains -- $HOME/.local/share/omarchy/bin $PATH
  fish_add_path $HOME/.local/share/omarchy/bin
end

if not contains -- $HOME/.local/bin $PATH
  fish_add_path $HOME/.local/bin
end

if type -q zoxide
  zoxide init fish | source
end

if type -q mise
  mise activate fish | source
end

alias lg='lazygit'
