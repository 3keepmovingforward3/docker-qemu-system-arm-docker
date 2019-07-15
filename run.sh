#!/usr/bin bash

# Benjamin Blouin

docker run -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static --rm -ti arm32v7/ros:kinetic-ros-base-xenial
