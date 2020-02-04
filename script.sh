#! /bin/bash
/usr/bin/ffmpeg -fflags +igndts -i rtmp://localhost/mytv/$1 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 1280x720 -b:v 1000K -bufsize 1000k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/dash/$1 2>>/var/log/ffmpeg-$1.log
