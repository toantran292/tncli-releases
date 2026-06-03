#!/usr/bin/env bash
set -euo pipefail

REPO="toantran292/tncli-releases"
INSTALL_DIR="${HOME}/.local/bin"

# Detect OS
case "$(uname -s)" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux" ;;
  *) echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

# Detect arch
case "$(uname -m)" in
  arm64|aarch64) ARCH="arm64" ;;
  x86_64|amd64)  ARCH="amd64" ;;
  *) echo "Unsupported arch: $(uname -m)"; exit 1 ;;
esac

NAME="tncli-${OS}-${ARCH}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo ">>> Fetching latest release info..."
TAG=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | head -1 | cut -d'"' -f4)
if [[ -z "$TAG" ]]; then
  echo "Failed to fetch latest tag"
  exit 1
fi
echo "    Latest: $TAG"

URL="https://github.com/${REPO}/releases/download/${TAG}/${NAME}.tar.gz"
echo ">>> Downloading $URL"
curl -fsSL -o "$TMP/tncli.tar.gz" "$URL"

echo ">>> Extracting..."
tar xzf "$TMP/tncli.tar.gz" -C "$TMP"

mkdir -p "$INSTALL_DIR"
mv "$TMP/${NAME}" "${INSTALL_DIR}/tncli"
chmod +x "${INSTALL_DIR}/tncli"

if [[ "$OS" == "darwin" ]]; then
  codesign -s - --force "${INSTALL_DIR}/tncli" 2>/dev/null || true
  xattr -rd com.apple.quarantine "${INSTALL_DIR}/tncli" 2>/dev/null || true
fi

# Ensure PATH
if ! command -v tncli >/dev/null 2>&1; then
  SHELL_RC="${HOME}/.zshrc"
  [[ -n "${BASH_VERSION:-}" ]] && SHELL_RC="${HOME}/.bashrc"
  if ! grep -q '.local/bin' "$SHELL_RC" 2>/dev/null; then
    echo '' >> "$SHELL_RC"
    echo '# tncli' >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo ">>> Added ~/.local/bin to PATH in $SHELL_RC (open new shell)"
  fi
fi

echo ""
echo "tncli ${TAG} installed to ${INSTALL_DIR}/tncli"
"${INSTALL_DIR}/tncli" version 2>/dev/null || true
