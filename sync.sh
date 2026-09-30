#!/bin/bash
# DOME 文件夹自动同步脚本：检测改动 → 提交 → 推送到 GitHub
REPO="/Users/xingyaqin/Documents/DOME"
export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

cd "$REPO" || { echo "$(date '+%H:%M:%S') ❌ 无法进入 $REPO"; exit 1; }

# 只在有改动时提交（避免空提交刷屏）
if [[ -n $(git status --porcelain) ]]; then
  git add -A
  msg="auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
  git commit -m "$msg" >/dev/null
  if git push origin main 2>&1; then
    echo "$(date '+%H:%M:%S') ✅ 已同步: $msg"
  else
    echo "$(date '+%H:%M:%S') ❌ 推送失败，检查网络/SSH 密钥"
  fi
else
  echo "$(date '+%H:%M:%S') ℹ️ 无改动，跳过"
fi
