#!/bin/bash
set -u
echo "=== Redis 服务的命令行 ==="
powershell -NoProfile -Command "(Get-CimInstance Win32_Service -Filter \"Name='Redis'\").PathName" 2>&1 | head -3

echo "=== 数据目录现有文件 ==="
ls -l /d/Redis/*.rdb /d/Redis/*.aof 2>/dev/null | head -5

echo "=== 服务配置文件的 dir 行 ==="
grep -n "^dir " /d/Redis/redis.windows-service.conf
