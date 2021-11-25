From osrf/ros:melodic-desktop-full
LABEL maintainer="Liang Qi <qiliang72@gmail.com>"

RUN apt update && apt install -q -y --no-install-recommends \
    wget curl git vim unzip \
    && rm -rf /var/lib/apt/lists/*

# install eigen
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz \
    && tar -xzvf eigen-3.3.7.tar.gz \
    && cd eigen-3.3.7 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install \
    && cd ../.. \
    && rm eigen-3.3.7.tar.gz \
    && rm -rf eigen-3.3.7

# install opencv
RUN apt update && apt install -q -y --no-install-recommends \
    build-essential \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libjpeg-dev \
    libswscale-dev \
    libtiff5-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/opencv/opencv/archive/3.4.14.zip \
    && unzip 3.4.14.zip \
    && cd opencv-3.4.14 \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. \
    && make -j4 \
    && make install \
    && cd ../.. \
    && rm 3.4.14.zip \
    && rm -rf opencv-3.4.14

# install ceres-solver
RUN apt update && apt install -q -y --no-install-recommends \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz \
    && tar -xvf ceres-solver-1.14.0.tar.gz \
    && cd ceres-solver-1.14.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j3 \
    && make test \
    && make install \
    && cd ../.. \
    && rm ceres-solver-1.14.0.tar.gz \
    && rm -rf ceres-solver-1.14.0

# install pcl1.8
RUN wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.8.1.tar.gz \
    && tar xvf pcl-1.8.1.tar.gz \
    && cd pcl-pcl-1.8.1 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j4 \
    && make install \
    && cd ../.. \
    && rm pcl-1.8.1.tar.gz \
    && rm -rf pcl-pcl-1.8.1

# install mlcc
RUN /bin/bash -c 'mkdir -p ~/catkin_ws/src \
    && cd ~/catkin_ws/src \
    && git clone https://github.com/hku-mars/mlcc.git \
    && cd .. \
    && source /opt/ros/melodic/setup.bash \
    && catkin_make'

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

COPY startup.sh /
ENTRYPOINT ["/startup.sh"]