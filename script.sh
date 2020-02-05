#! /bin/bash
/usr/bin/ffmpeg -fflags +igndts -i rtmp://localhost/mytv/$1 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 1920x1080 -b:v 5000K -bufsize 5500k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1_1080 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 1280x720 -b:v 1000K -bufsize 1500k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1_720 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 854x480 -b:v 500K -bufsize 550k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1_480 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 640x360 -b:v 400K -bufsize 450k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1_360 \
                -c:v libx264 -c:a aac -preset ultrafast -tune zerolatency -async 1 -s 426x240 -b:v 200K -bufsize 250k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1_240 \
                2>>/var/log/ffmpeg-$1.log