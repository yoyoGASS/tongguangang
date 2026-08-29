#!/bin/sh
# 把最新的建置推上 GitHub Pages。
# 用法：先在專案根目錄跑 python scripts/build.py，再執行這支。
set -e
cd "$(dirname "$0")"
cp ../dist/index.html index.html
git add -A
if git diff --cached --quiet; then
  echo "沒有變更，不用推。"
  exit 0
fi
git commit -q -m "更新 $(date +%Y-%m-%d\ %H:%M)"
git push -q
echo "已推送。約一分鐘後生效：https://yoyogass.github.io/tongguangang/"
