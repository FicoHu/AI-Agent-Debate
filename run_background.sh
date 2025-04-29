#!/bin/bash

# 设置日志文件
LOG_FILE="update_and_run.log"

# 清空日志文件
> $LOG_FILE

# 在后台运行update_and_run.sh脚本，并将输出重定向到日志文件
nohup ./update_and_run.sh >> $LOG_FILE 2>&1 &

# 获取后台进程ID
BACKGROUND_PID=$!

# 输出信息
echo "脚本已在后台启动，进程ID: $BACKGROUND_PID"
echo "您可以通过以下命令查看日志："
echo "  tail -f $LOG_FILE"
echo "要停止脚本，请运行："
echo "  kill $BACKGROUND_PID"

# 将进程ID保存到文件中，以便之后可以停止它
echo $BACKGROUND_PID > .background_pid
