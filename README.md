# docker-qemu-system-arm-docker
Arm python dev qemu-system-arm Docker Container  

The Raspberry Pi™ is good at many things, but it is very slow at compiling from source. It is to our advantage to emulate the arm32v7 instuction set on a faster cpu, because even running the emulation in a VM will be many orders of magnitude faster than host-system source compilations.  Wrining out as much performance as possible is needed to increase the charactersitics needed for any applcation, if not especially realtime (RTOS) and near-realtime (rt-patched kernel/linux userland) systems.
One caveat is not all soc features are emulatable atm, in this case the NEON fp instructions. So the -mfpu= floating-point modification flag can not include neon; i.e. -march=vfpv4 is okay but -march=neon-vfpv4 would fail to compile. This is due to limitations in the qemu system emulator; on the up side, NEON instructions are instructions-per-clock (ipc)delta volatile, where vfpv4 instructions are less so. This, we hope, can have a lower latency, more realtime system.
