wine-gptk() {
    WINEESYNC=1 WINEPREFIX=~/my-game-prefix $(brew --prefix game-porting-toolkit)/bin/wine64 "$@"
}
