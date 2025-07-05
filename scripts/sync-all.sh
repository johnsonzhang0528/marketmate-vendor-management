#!/bin/bash

echo "��� 同步所有 Worktree..."

# 定義 worktree 列表
worktrees=("frontend" "backend" "inventory" "pos" "customer" "analytics" "mobile" "docs")

for worktree in "${worktrees[@]}"; do
  echo "��� 同步 $worktree..."
  cd "../worktrees/$worktree"
  git pull origin "feature/$worktree"
  cd - > /dev/null
done

echo "✅ 所有 Worktree 同步完成！"
