#!/bin/sh

cd $HOME

# update the general package
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git autoconf

# install nvidia driver
sudo apt-add-repository ppa:xorg-edgers/ppa
sudo apt-get update
sudo apt-get install nvidia-current nvidia-settings

# install opencl SDK
cd ~/
mkdir opencl
cd opencl
wget http://registrationcenter.intel.com/irc_nas/3142/intel_sdk_for_ocl_applications_2013_xe_sdk_3.0.67279_x64.tgz
tar -xzvf intel_sdk_for_ocl_applications_2013_xe_sdk_3.0.67279_x64.tgz
cd intel_sdk_for_ocl_applications_2013_xe_sdk_3.0.67279_x64
sudo apt-get install -y rpm alien libnuma1
for f in *.rpm; do
  fakeroot alien --to-deb $f
done
for f in *.deb; do
  sudo dpkg -i $f
done
sudo ln -s /opt/intel/opencl-1.2-3.0.67279/etc/intel64.icd /etc/OpenCL/vendors/intel64.icd
sudo ln -s /opt/intel/opencl-1.2-3.0.67279/lib64/libOpenCL.so /usr/lib/libOpenCL.so
sudo ldconfig

# test opencl
cd ~/opencl
wget https://gist.githubusercontent.com/rmcgibbo/6314452/raw/752cb3d14170fa7defb1ed37e3c2ce286248bb95/clDeviceQuery.cpp
g++ -o clDeviceQuery -I/opt/intel/opencl-1.2-3.0.67279/include clDeviceQuery.cpp -lOpenCL
./clDeviceQuery

# compile yasm
cd ~/
mkdir bin ffmpeg_sources ffmpeg_build benchmark
cd ~/ffmpeg_source
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm 
autoreconf -fiv
./configure
make
sudo make install
sudo make distclean

# compile x264
cd ~/ffmpeg_sources
rm -rf x264
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --bindir="$HOME/bin" --enable-static --enable-gprof
make 
sudo make install 
sudo make distclean
sudo ldconfig

#download test avi
cd ~/
wget https://ia600401.us.archive.org/11/items/Architects_of_Tomorrow/Psy-12.avi
mv Psy-12.avi test.avi