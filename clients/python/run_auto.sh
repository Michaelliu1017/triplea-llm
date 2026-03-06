#!/bin/bash
# 在虚拟环境中运行全自动对战，无需每次手动 source .venv
cd "$(dirname "$0")"
if [ ! -d ".venv" ]; then
  echo "正在创建虚拟环境并安装 openai..."
  python3 -m venv .venv
  .venv/bin/pip install openai
fi
if [ -z "$OPENAI_API_KEY" ]; then
  echo "请先设置: export OPENAI_API_KEY=sk-你的key"
  exit 1
fi
exec .venv/bin/python chatgpt_driver.py --auto "$@"
