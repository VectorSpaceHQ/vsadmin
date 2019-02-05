#!/bin/bash
# i've spent way too much time trying to figure out how to restart
# vsfs01-share.mount in a clean way. So I'm making a cron job
systemctl restart vsfs01-share.mount
