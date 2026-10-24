#!/bin/bash
# 等待设备上线(正常系统)后自动抓取密码验证相关日志
for i in $(seq 1 240); do
  st=$(adb devices 2>&1 | grep 10AF)
  if echo "$st" | grep -qE "device$"; then
    mode=$(adb -s 10AF59276U006BH shell getprop ro.boot.mode 2>/dev/null)
    echo "[$(date +%T)] device online, mode=$mode"
    if [ "$mode" != "recovery" ]; then
      adb -s 10AF59276U006BH shell 'logcat -d -v threadtime' > logs/norm-system-logcat.txt 2>&1
      adb -s 10AF59276U006BH shell 'dmesg' > logs/norm-system-dmesg.txt 2>&1
      echo "=== 日志已抓取 ==="
      grep -aiE "gatekeeper|weaver|synthetic|password|fbe|user.*key|keymint|keystore2" logs/norm-system-logcat.txt | tail -60
      exit 0
    fi
  fi
  sleep 5
done
echo "240 次轮询超时"
