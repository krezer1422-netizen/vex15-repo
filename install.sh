set -e

GITHUB_USER="krezer1422-netizen"
GITHUB_REPO="vex15-repo"
BRANCH="main"

RAW_BASE="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}"
BIN_URL="${RAW_BASE}/vex15"

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ]; then
    INSTALL_DIR="$PREFIX/bin"
else
    INSTALL_DIR="/usr/local/bin"
fi
BIN_PATH="${INSTALL_DIR}/vex15"

if ! command -v php >/dev/null 2>&1; then
    if command -v pkg >/dev/null 2>&1; then
        pkg install php -y >/dev/null 2>&1
    elif command -v apt >/dev/null 2>&1; then
        apt install php -y >/dev/null 2>&1
    else
        echo -e "${RED}✘ PHP topilmadi. Avval qo'lda o'rnating: pkg install php${RESET}"
        exit 1
    fi
fi

DOWNLOAD_OK=0

if [ -w "$INSTALL_DIR" ]; then
    curl -fsSL "$BIN_URL" -o "$BIN_PATH" 2>/dev/null && DOWNLOAD_OK=1
elif command -v sudo >/dev/null 2>&1; then
    sudo curl -fsSL "$BIN_URL" -o "$BIN_PATH" 2>/dev/null && DOWNLOAD_OK=1
fi

if [ "$DOWNLOAD_OK" -ne 1 ]; then
    echo -e "${RED}✘ O'rnatishda xatolik yuz berdi. Internetni tekshiring.${RESET}"
    exit 1
fi

chmod 755 "$BIN_PATH" 2>/dev/null || sudo chmod 755 "$BIN_PATH" 2>/dev/null

if command -v vex15 >/dev/null 2>&1; then
    echo -e "${GREEN}✔ VEX15 muvaffaqiyatli o'rnatildi!${RESET}"
    echo -e "${CYAN}$(vex15 -v)${RESET}"
else
    echo -e "${RED}✘ Nimadir xato ketdi. Terminalni yopib qayta oching.${RESET}"
fi
