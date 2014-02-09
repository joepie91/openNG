#!/bin/bash
sass --watch scss/:public_html/static/css/ > sasswatch.log 2> sasswatch.err &
echo $! > sasswatch.pid
