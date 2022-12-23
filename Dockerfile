#Download base image ubuntu 16.04 (Xenial)
FROM ubuntu:16.04

WORKDIR /usr/src/app

# Update Ubuntu Software repository
RUN apt-get update

# Install needed packages to compile
RUN apt-get install -y build-essential sudo git wget libncurses-dev unzip bzip2 

# crossbuild-essential-arm64

# download ARM compiler
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2
RUN sudo tar xjf gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2 -C /usr/share/
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-g++
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-gdb /usr/bin/arm-none-eabi-gdb
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-size /usr/bin/arm-none-eabi-size
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-objcopy /usr/bin/arm-none-eabi-objcopy
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-ar /usr/bin/arm-none-eabi-ar
RUN sudo ln -s /usr/share/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-objdump /usr/bin/arm-none-eabi-objdump
RUN sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
RUN sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6 /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Clone the pitrex repository
# RUN command git clone https://github.com/malbanGit/pitrex-baremetal pitrex
# RUN command git clone https://github.com/gtoal/pitrex
RUN command git clone https://github.com/tullulah/pitrex-baremetal pitrex

# Download missing roms
RUN wget "https://arcarc.xmission.com/Web%20Archives/ionpool.net%20(Dec-31-2020)/arcade/cine/tail_gunner_roms.zip" & \
wget "https://archive.org/download/MAME0.37b5_MAME2000_Reference_Set_Update_2_ROMs_Samples/roms/asteroid.zip"

RUN mkdir /opt/pitrex/ 
RUN mkdir /opt/pitrex/roms/ 
RUN mkdir /opt/pitrex/roms/tailgunner/

RUN unzip tail_gunner_roms.zip -d /opt/pitrex/roms/tailgunner/
RUN mv /opt/pitrex/roms/tailgunner/TAILGUNR.U7 /opt/pitrex/roms/tailgunner/tailg.u7 
RUN mv /opt/pitrex/roms/tailgunner/TAILGUNR.T7 /opt/pitrex/roms/tailgunner/tailg.t7
RUN mv /opt/pitrex/roms/tailgunner/TAILGUNR.P7 /opt/pitrex/roms/tailgunner/tailg.p7
RUN mv /opt/pitrex/roms/tailgunner/TAILGUNR.R7 /opt/pitrex/roms/tailgunner/tailg.r7 

RUN unzip asteroid.zip -d /usr/src/app/pitrex/asteroid_sbt/

RUN cp /usr/src/app/pitrex/asteroid_sbt/035127.02 /usr/src/app/pitrex/asteroid_sbt/035127-02.np3
RUN cp /usr/src/app/pitrex/asteroid_sbt/035143.02 /usr/src/app/pitrex/asteroid_sbt/035143-02.j2
RUN cp /usr/src/app/pitrex/asteroid_sbt/035144.02 /usr/src/app/pitrex/asteroid_sbt/035144-02.h2
RUN cp /usr/src/app/pitrex/asteroid_sbt/035145.02 /usr/src/app/pitrex/asteroid_sbt/035145-02.ef2

RUN mkdir /media/sf_E_DRIVE/
RUN mkdir /media/sf_E_DRIVE/piZero1/

WORKDIR /usr/src/app/pitrex/
# RUN make clean
RUN make

CMD ["/bin/bash"]