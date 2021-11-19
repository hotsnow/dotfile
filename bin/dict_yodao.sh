#!/bin/sh

#curl "http://dict.youdao.com/search?tab=&keyfrom=dict.top&q=$1&btnG=" 2>/dev/null |/usr/bin/w3m -dump -T text/html | tail -n +10 |less
curl "http://dict.youdao.com/search?q=$1&btnindex=&ue=utf8&keyfrom=dict.index" 2>/dev/null |/usr/bin/w3m -dump -T text/html | tail -n +10 |less
#curl "http://dict.cn/"$1".htm" 2>/dev/null |/usr/bin/w3m -dump -T text/html | sed '1,/^embed/d' |less
#http://dict.cn/my-word.htm
