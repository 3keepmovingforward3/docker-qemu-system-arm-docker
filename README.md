# Docker-qemu-system-arm
Arm python dev qemu-system-arm Docker Container  

The Raspberry Pi™ is good at many things, but it is very slow at compiling from source. It is to our advantage to emulate the arm32v7 instuction set on a faster cpu, because even running the emulation in a VM will be many orders of magnitude faster than host-system source compilations.  Wrining out as much performance as possible is needed to increase the charactersitics needed for any applcation, if not especially realtime (RTOS) and near-realtime (rt-patched kernel/linux userland) systems.  
One caveat is not all soc features are emulatable atm, in this case the NEON fp instructions. So the -mfpu= floating-point modification flag can not include neon; i.e. -march=vfpv4 is okay but -march=neon-vfpv4 would fail to compile. This is due to limitations in the qemu system emulator; on the up side, NEON instructions are instructions-per-clock (ipc)delta volatile, where vfpv4 instructions are less so. This, we hope, can have a lower latency, more realtime system.  
The Docker container is very useful, allowing full control at image, contianer, and container file-system access levels, even whilst a container is running. The drawbacks, in expansion of what has been expanded on previously, also include "sudo" level events, as well as cli piping especially of "apt" commands. For this reason I won't be doing any update/upgrade command scripting.  

# Missing Software  
*Base-Toolchains Upgrade*  
`apt update`  
`apt install -y software-properties-common`  
`add-apt-repository ppa:ubuntu-toolchain-r/test`  
`apt update`  
`apt upgrade -y`  
*Latest-Toolchains*  
`apt install -y gcc-9 g++-9 gfortran-9 cloog-isl`  
*Dev-Package-Dev*  
`apt install -y sudo git wget curl bison flex gcc g++ gfortran python python3 libopenblas-dev libatlas-base-dev libssl-dev   libmpfr-dev build-essential python-pip python3-pip libreadline-dev apt-utils liblzma-dev python-scipy libhdf5-dev libc-ares-dev libeigen3-dev openjdk-8-jdk openmpi-bin libopenmpi-dev`  

# Environment Setup  
*Toolchain-Flags*  
`export CFLAGS="-march=armv7a-a -mtune=cortex-a53 -mfpu=vfpv4 -Ofast -pipe"`  
`export CXXFLAGS="-march=armv7a-a -mtune=cortex-a53 -mfpu=vfpv4 -Ofast -pipe"`  
`export CC="gcc-9"`  
`export CXX="g++-9"`  

# Python Dependencies Setup  
`pip install -vv --user --no-binary all typing pyyaml future cython`  
`pip install -vv --user --no-binary all numpy scipy h5py six numpy wheel mock`  
`pip install -vv --user --no-binary keras_applications==1.0.7 --no-deps`  
`pip install -vv --user --no-binary keras_preprocessing==1.0.9 --no-deps`  
