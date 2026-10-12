#!/bin/bash
# 关闭后端、编译打包、重启
set -u

echo "=== 关闭后端 ==="
PID=$(powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"name='java.exe'\" | Where-Object { \$_.CommandLine -like '*ruoyi-admin.jar*' } | Select-Object -ExpandProperty ProcessId" 2>/dev/null | tr -d '\r' | head -1)
if [ -n "$PID" ]; then
  echo "  PID=$PID"
  powershell -NoProfile -Command "Stop-Process -Id $PID -Force" 2>&1 | head -1
  sleep 3
else
  echo "  没有在跑的后端"
fi

cd "E:/Desktop/2023毕设/董/项目/backend" || exit 1
M="E:\\maven\\apache-maven-3.9.9"
JV="C:/Program Files/BellSoft/LibericaJDK-21/bin/java"

echo "=== 编译 ==="
"$JV" -classpath "$M\\boot\\plexus-classworlds-2.8.0.jar" \
  "-Dclassworlds.conf=$M\\bin\\m2.conf" "-Dmaven.home=$M" \
  "-Dmaven.multiModuleProjectDirectory=E:\\Desktop\\2023毕设\\董\\项目\\backend" \
  org.codehaus.plexus.classworlds.launcher.Launcher -o -pl ruoyi-admin -am package -DskipTests 2>&1 \
  | grep -E "BUILD|ERROR" | head -20

echo "=== 启动 ==="
nohup "$JV" -jar ruoyi-admin/target/ruoyi-admin.jar >> backend-run.log 2>&1 &
for i in $(seq 1 40); do
  sleep 3
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://localhost:8080/captchaImage 2>/dev/null)
  if [ "$c" = "200" ]; then echo "  就绪，用时 $((i*3)) 秒"; exit 0; fi
done
echo "  启动超时"
exit 1
