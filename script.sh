#! /bin/bash
echo -e 'hello\n\n\n\n\n\nhello'
/usr/bin/ffmpeg -i rtmp://localhost/mytv/$1 \
                -b:a 64k -c:v libx264 -preset fast -profile:v baseline -vsync cfr -s 1280x720 -b:v 2500K -bufsize 2500k -f flv \
                -max_muxing_queue_size 1024 rtmp://localhost/dash/$1 2>>/var/log/ffmpeg-$name.log
