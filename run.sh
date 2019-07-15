#!/usr/bin bash

# Benjamin Blouin
# 13JUL19

docker run -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static --rm -ti arm32v7/ros:kinetic-ros-base-xenial
