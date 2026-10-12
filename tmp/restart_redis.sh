#!/bin/bash
# 备份并重启 Redis 服务，让 AOF 配置生效
set -u

echo "=== 重启前的会话 ==="
redis-cli keys "login_tokens:*" | wc -l

echo "=== 触发一次 RDB 落盘（保住重启前的数据）==="
redis-cli bgsave 2>&1 | head -1
sleep 3
redis-cli info persistence 2>/dev/null | grep -E "rdb_last_bgsave_status|rdb_changes_since_last_save" | head -2

echo "=== 重启 Redis 服务 ==="
powershell -NoProfile -Command "Restart-Service -Name Redis -Force" 2>&1 | head -3
sleep 5

echo "=== 服务状态 ==="
powershell -NoProfile -Command "Get-Service Redis | Select-Object Name,Status | Format-List" 2>&1 | grep -v '^$' | head -4

echo "=== 重启后配置确认 ==="
redis-cli config get appendonly 2>&1 | tail -1
redis-cli config get dir 2>&1 | tail -1

echo "=== 重启后剩余会话 ==="
redis-cli keys "login_tokens:*" | wc -l
