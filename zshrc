# 1. NAJPIERW INSTANT PROMPT (musi być na samej górze)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. TERAZ NADPISUJEMY ŚCIEŻKĘ DO WTYCZEK (żeby brało z Twojego domowego folderu, a nie roota)
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export QT_QPA_PLATFORMTHEME=qt6ct

# 3. KONFIGURACJA CACHYOS I OH MY ZSH
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# 4. TWOJE MOTYWY I PLUGINY
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git sudo extract zsh-autosuggestions zsh-syntax-highlighting)

# 5. NA SAMYM DOLE (Konfiguracja wyglądu p10k i bajery)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH=~/.npm-global/bin:$PATH
