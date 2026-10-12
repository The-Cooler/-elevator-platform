#!/bin/bash
# 查 redis 进程的启动方式，判断是服务还是手动启动
set -u
echo "=== redis-server 进程 ==="
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"name='redis-server.exe'\" | Select-Object ProcessId,CommandLine | Format-List" 2>&1 | grep -v '^$' | head -10

echo "=== 是否注册为 Windows 服务 ==="
powershell -NoProfile -Command "Get-Service | Where-Object { \$_.Name -like '*redis*' } | Select-Object Name,Status,StartType | Format-List" 2>&1 | grep -v '^$' | head -8

echo "=== 配置文件 ==="
ls -l /d/Redis/*.conf 2>/dev/null

echo "=== redis.windows.conf 里的 appendonly ==="
grep -n "^appendonly\|^appendfsync\|^save " /d/Redis/redis.windows.conf 2>/dev/null | head -8
