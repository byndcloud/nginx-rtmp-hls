#! /bin/bash
/usr/bin/ffmpeg -i rtmp://localhost/mytv/$1 \
                -b:a 64k -c:v libx264 -c:a aac -preset fast -profile:v baseline -vsync cfr -s 1280x720 -b:v 2500K -bufsize 2500k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/hls/$1 2>>/var/log/ffmpeg-$1.log