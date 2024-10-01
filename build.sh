#!/bin/bash

# Define paths
## After git clone --recursive https://github.com/opencv/opencv-python.git
OPENCV_SOURCE_DIR="/home/younes/opencv-python/opencv" # to be adapted to the clonned directory
BUILD_DIR="${OPENCV_SOURCE_DIR}/build"
FFMPEG_PATH="/usr/local"

# Ensure the build directory exists and navigate to it
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Set environment variables
export LD_LIBRARY_PATH="${FFMPEG_PATH}/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="${FFMPEG_PATH}/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_LIBDIR="${PKG_CONFIG_PATH}"

# Run CMake with desired configurations, including Python 3 bindings and GTK+ support
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX="$HOME/Applications/opencv" \
      -D BUILD_EXAMPLES=ON \
      -D BUILD_TESTS=OFF \
      -D OPENCV_EXTRA_EXE_LINKER_FLAGS="-Wl,-rpath,${FFMPEG_PATH}/lib" \
      -D BUILD_opencv_python3=ON \
      -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
      -D PYTHON3_EXECUTABLE=$(which python3) \
      -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
      -D WITH_GTK=ON \
      "${OPENCV_SOURCE_DIR}"

# Build and install OpenCV
make -j$(nproc)
make install

# Navigate into the python_loader folder
cd "${BUILD_DIR}/python_loader"
python3 setup.py develop
