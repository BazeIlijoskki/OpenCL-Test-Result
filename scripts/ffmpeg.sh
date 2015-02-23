# ffmpeg

# 1. All processor specific perf flags disabled(e.g. sse3, avx2 where applicable).  See /proc/cpuinfo and gcc feature flags.
cd ~/ffmpeg_sources
rm -rf ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
./configure --prefix="$HOME/ffmpeg_build" --enable-gpl --enable-libx264 --bindir="$HOME/bin" --disable-mmx --disable-mmxext --disable-sse --disable-sse2 --disable-sse3 --disable-ssse3 --disable-sse4 --disable-sse42 --disable-avx --disable-xop --disable-avx2 --extra-cflags="-pg" --extra-cxxflags="-pg" --extra-ldflags="-pg" --extra-ldexeflags="-pg"
make
make install
make distclean
hash -r

# test
cd ~/
rm -rf benchmark/1
rm gmon.*
mkdir benchmark/1
./bin/ffmpeg -i test.avi -c:v libx264 -vf deshake output.mkv -report
gprof bin/x264 gmon.out > gmon.log
mv gmon.out benchmark/1/
mv gmon.log benchmark/1/
mv ffmpeg-*.log benchmark/1/

# 2. All processor specific perf flags enabled (e.g. sse3, avx2 where applicable).  See /proc/cpuinfo and gcc feature flags.
cd ~/ffmpeg_sources
rm -rf ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
./configure --prefix="$HOME/ffmpeg_build" --enable-gpl --enable-libx264 --bindir="$HOME/bin" --extra-cflags="-pg" --extra-cxxflags="-pg" --extra-ldflags="-pg" --extra-ldexeflags="-pg"
make
make install
make distclean
hash -r

# test
cd ~/
rm -rf benchmark/2
rm -f gmon.*
rm -f output.mkv
rm -f ffmpeg-*.log
mkdir benchmark/2
./bin/ffmpeg -i test.avi -c:v libx264 -vf deshake output.mkv -report
gprof bin/x264 gmon.out > gmon.log
mv gmon.out benchmark/2/
mv gmon.log benchmark/2/
mv ffmpeg-*.log benchmark/2/

# 3. Multithread off
cd ~/ffmpeg_sources
rm -rf ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
./configure --prefix="$HOME/ffmpeg_build" --enable-gpl --enable-libx264 --bindir="$HOME/bin" --disable-pthreads --extra-cflags="-pg" --extra-cxxflags="-pg" --extra-ldflags="-pg" --extra-ldexeflags="-pg"
make
make install
make distclean
hash -r

# test
cd ~/
rm -rf benchmark/3
rm -f gmon.*
rm -f output.mkv
rm -f ffmpeg-*.log
mkdir benchmark/3
./bin/ffmpeg -i test.avi -c:v libx264 -vf deshake output.mkv -report
gprof bin/x264 gmon.out > gmon.log
mv gmon.out benchmark/3/
mv gmon.log benchmark/3/
mv ffmpeg-*.log benchmark/3/

# 4. OpenCL enabled (run where applicable)
cd ~/ffmpeg_sources
rm -rf ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
./configure --prefix="$HOME/ffmpeg_build" --enable-gpl --enable-libx264 --bindir="$HOME/bin" --extra-cflags="-I/opt/intel/opencl-1.2-3.0.67279/include" --enable-opencl --extra-cflags="-pg" --extra-cxxflags="-pg" --extra-ldflags="-pg" --extra-ldexeflags="-pg"
make
make install
make distclean
hash -r

# test
cd ~/
rm -rf benchmark/4
rm -f gmon.*
rm -f output.mkv
rm -f ffmpeg-*.log
mkdir benchmark/4
./bin/ffmpeg -i test.avi -c:v libx264 -vf deshake=opencl=1 output.mkv -report
gprof bin/x264 gmon.out > gmon.log
mv gmon.out benchmark/4/
mv gmon.log benchmark/4/
mv ffmpeg-*.log benchmark/4/