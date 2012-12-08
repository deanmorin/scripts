#!/bin/bash
echo "Total usage shown for rmnet0 in /proc/net/dev:  $(adb shell cat /proc/net/dev | grep rmnet0 | tr -dc [\ 0-9] | sumrow)"
