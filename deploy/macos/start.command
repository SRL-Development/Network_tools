#!/bin/bash
set -e
cd "$(dirname "$0")"

case "$(uname -m)" in
  arm64) BIN="netops-console-macos-arm64" ;;
  x86_64) BIN="netops-console-macos-x64" ;;
  *) echo "不支持的处理器架构：$(uname -m)"; read -r; exit 1 ;;
esac

chmod +x "$BIN"
xattr -dr com.apple.quarantine "$BIN" 2>/dev/null || true
if ! codesign --verify "$BIN" >/dev/null 2>&1; then
  echo "正在为本机架构添加 ad-hoc 签名…"
  codesign --force --sign - "$BIN"
fi
./"$BIN"
