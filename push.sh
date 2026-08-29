#!/bin/sh
# 把最新的公開建置推上 GitHub Pages。
# 用法：先在專案根目錄跑 python scripts/build.py，再執行這支。
set -e
cd "$(dirname "$0")"
cp ../dist/index.html index.html

# 保險：公開版的 DEFAULT_PICS 一定要是 null。
# 家用版（scripts/family.py 產的）把圖烤進去了，那一份不可以上公開的 repo。
if ! grep -q '__DEFAULTPICS__\*/null' index.html; then
  echo "停止：這個檔案內嵌了夥伴圖，不是公開版。"
  echo "請跑 python scripts/build.py 重新產生乾淨的 dist/index.html。"
  git checkout -- index.html 2>/dev/null || true
  exit 1
fi
if grep -qc 'data:image/webp;base64' index.html && [ "$(grep -o 'data:image/webp;base64' index.html | wc -l)" -gt 0 ]; then
  echo "停止：檔案裡有內嵌的圖片資料。"
  git checkout -- index.html 2>/dev/null || true
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "沒有變更，不用推。"
  exit 0
fi
git commit -q -m "更新 $(date +%Y-%m-%d\ %H:%M)"
git push -q
echo "已推送。約一分鐘後生效：https://yoyogass.github.io/tongguangang/"
