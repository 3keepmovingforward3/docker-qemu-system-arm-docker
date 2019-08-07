# Docker-qemu-system-arm
Arm python dev qemu-system-arm Docker Container  

The Raspberry Pi™ is good at many things, but it is very slow at compiling from source. It is to our advantage to emulate the arm32v7 instuction set on a faster cpu, because even running the emulation in a VM will be many orders of magnitude faster than host-system source compilations.  Wrining out as much performance as possible is needed to increase the charactersitics needed for any applcation, if not especially realtime (RTOS) and near-realtime (rt-patched kernel/linux userland) systems. Increased compilation speeds lead another advantage, most Python dependencies can be compiled from source with optimization flags enabled that would normally fall outside effecient use of time for compilation.  
One caveat is not all soc features are emulatable atm, in this case the NEON fp instructions. So the -mfpu= floating-point modification flag can not include neon; i.e. -march=vfpv4 is okay, but -march=neon-vfpv4 would fail to compile. This is due to limitations in the qemu system emulator; on the up side, NEON instructions are instructions-per-clock (ipc)delta volatile, where vfpv4 instructions are less so. This, we hope, can have a lower latency, more realtime system.  
The Docker container is very useful, allowing full control at image, contianer, and container file-system access levels, even whilst a container is running. The drawbacks, in expansion of what has been expanded on previously, also include "sudo" level events, as well as cli piping especially of "apt" commands. For this reason I won't be doing any update/upgrade command scripting.  

# Running Docker Container
**Required host-system software**  
`apt update && apt upgrade -y`  
`apt install -y qemu-system-arm docker.io`  
*Docker should not be run as sudo/su; we will add a docker group, and add the current user as group member*  
`groupadd docker`  
`usermod -aG docker $USER`  
*Logout/login*  
`docker run -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static --rm -ti arm32v7/ros:kinetic-ros-base-xenial`  

# Missing Software  
**Base-Toolchains Upgrade**  
`apt update`  
`apt install -y software-properties-common apt-utils`  
`add-apt-repository ppa:ubuntu-toolchain-r/test`  
`apt update`  
`apt upgrade -y`  
*Latest-Toolchains*  
`apt install -y gcc-9 g++-9 gfortran-9 cloog-isl`  
*Dev-Package-Dev*  
`apt install -y sudo git wget curl bison flex gcc g++ gfortran cmake libgmp-dev libmpc-dev libmpfr-dev build-essential python python3 libopenblas-dev libatlas-base-dev libssl-dev cython python-pip python3-pip python3-dev python3-yaml python3-setuptools python-yaml libreadline-dev texinfo libusb-dev libsnappy-dev liblzma-dev python-scipy libhdf5-dev libc-ares-dev libeigen3-dev libblas-dev openjdk-8-jdk openmpi-bin libopenmpi-dev libffi-dev cmake checkinstall`  

# Environment Setup  
**Toolchain Flags**  
*Flag Option Explanations*  
"export": sets global environment (env) variable;  
"microarchitecture": -march;  
"microarchitecture tuning" -mtune;  
"march-floating-point-unit": -mfpu;  
"-march big/little endian msb/lsb": -mlittle-endian;  
"Specifies which floating-point ABI to use": -mfloat-abi=hard  
"IEEE non-compliant compiler optimizations": -Ofast;  
"pipe output (-o) files instead of writing to disk": -pipe  
`export CFLAGS="-march=armv7-a -mtune=cortex-a53 -mfpu=vfpv4 -mlittle-endian -mfloat-abi=hard -Ofast -pipe"`  
`export CXXFLAGS="-march=armv7-a -mtune=cortex-a53 -mfpu=vfpv4 -mlittle-endian -mfloat-abi=hard -Ofast -pipe"`  
`export CC="gcc-9"`  
`export CXX="g++-9"`  
`export USE_CUDA=0`  
`export USE_DISTRIBUTED=0`  
`export USE_MKLDNN=0`  
`export USE_NNPACK=0`  
`export USE_QNNPACK=0`  
`export MAX_JOBS=$(nproc)`  
  
**Example of how environment flags make there way into the gcc compilation command**  
**gcc-9** -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fno-strict-aliasing **-march=armv7-a -mtune=cortex-a53 -mfpu=vfpv4 -mlittle-endian -Ofast -pipe** -fPIC -DH5_USE_16_API -I/tmp/pip-build-5kTuo7/h5py/lzf -I/usr/include/hdf5/serial -I/opt/local/include -I/usr/local/include -I/usr/lib/python2.7/dist-packages/numpy/core/include -I/usr/include/python2.7 -c /tmp/pip-build-5kTuo7/h5py/h5py/h5r.c -o build/temp.linux-armv7l-2.7/tmp/pip-build-5kTuo7/h5py/h5py/h5r.o  
**Example of how environment flags make there way into the cmake compilation command**  
**cmake** -DBUILD_PYTHON=True -DBUILD_TEST=True -DCMAKE_BUILD_TYPE=Release **-DCMAKE_CXX_FLAGS=-march=armv7-a -mtune=cortex-a53 -mfpu=vfpv4 -mlittle-endian -Ofast -pipe  -DCMAKE_C_FLAGS=-march=armv7-a -mtune=cortex-a53 -mfpu=vfpv4 -mlittle-endian -Ofast -pipe**  -DCMAKE_EXE_LINKER_FLAGS= -DCMAKE_INSTALL_PREFIX=/pytorch_install/pytorch/torch -DCMAKE_PREFIX_PATH=/opt/ros/kinetic -DCMAKE_SHARED_LINKER_FLAGS= -DINSTALL_TEST=True -DNUMPY_INCLUDE_DIR=/usr/lib/python2.7/dist-packages/numpy/core/include -DPYTHON_EXECUTABLE=/usr/bin/python -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so.1.0 -DTORCH_BUILD_VERSION=1.2.0a0+388dc4f **-DUSE_CUDA=False -DUSE_DISTRIBUTED=False -DUSE_MKLDNN=0 -DUSE_NNPACK=0** -DUSE_NUMPY=True **-DUSE_QNNPACK=0** -DUSE_SYSTEM_EIGEN_INSTALL=OFF /pytorch_install/pytorch  

# Python Dependencies Setup 
**Python Package Manger Flags**  
*Flag Option Explanations*  
"verbosity level": -v -vv -vvv; "install under user": --user; "compile from source": --no-binary all; "specific version": *==1.0.*;  
`time pip install -vv --user --no-binary all typing pyyaml future cython scipy h5py six numpy wheel mock`  
`pip install -vv --user --no-deps --no-binary all keras_applications==1.0.7 keras_preprocessing==1.0.9`    

# Pytorch Build  
*Time to completion Python2 ≃ 160 min*  
`mkdir pytorch_install && cd pytorch_install`  
`git clone --depth=1 --recursive https://github.com/pytorch/pytorch && cd pytorch`  
`time python setup.py bdist_wheel`  
or  
`time python3 setup.py bdist_wheel`  

# Export from Docker container
**Need enough free diskspace on host-system to have an entire copy of build-system filesystem**
`docker ps -a`
*Find the container id for the system you have been developing in; export command saves to STDOUT*  
`docker export 8916fff1a7c8 > save.tar`  
`mkdir ~/save`  
`sudo tar xf save.tar -C ~/save`  
`sudo chown -hR $USER save/`
*The wheel file can be found in the 'dists' folder; e.g. ~/pytorch_install/pytorch/dist*  
*Instrallation*  
`pip install --user torch-1.2.0a0+388dc4f-cp27-cp27mu-linux_armv7l.whl`  

# QEMU Error List
**List for completeness**  
*All emulation messages are benign and take the form as below:*  
qemu: Unsupported syscall: 319

# References
1.  ARM GCC Compiler Info: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.100748_0606_00_en/fnb1472741490155.html  
2.  GCC Compiler Optimization Options That Control Optimization: https://gcc.gnu.org/onlinedocs/gcc-9.1.0/gcc/Optimize-Options.html#Optimize-Options
3.  GCC ARM Options: https://gcc.gnu.org/onlinedocs/gcc-9.1.0/gcc/ARM-Options.html#ARM-Options
