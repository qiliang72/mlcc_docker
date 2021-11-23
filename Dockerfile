From osrf/ros:melodic-desktop-full-bionic
LABEL maintainer="Liang Qi <qiliang72@gmail.com>"

RUN apt update && apt install -q -y --no-install-recommends \
    wget \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz \
#     && tar -xzvf eigen-3.3.7.tar.gz -C /usr/local/include \
#     && mv /usr/local/include/eigen-3.3.7 /usr/local/include/eigen3 \
#     && cp -r /usr/local/include/eigen3/Eigen /usr/local/include \
#     && rm eigen-3.3.7.tar.gz

RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz \
    && tar -xzvf eigen-3.3.7.tar.gz \
    && cd eigen-3.3.7 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install \
    && cd .. \
    && rm -rf eigen-3.3.7

RUN apt update && apt install -q -y --no-install-recommends \
    unzip \
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
    && cd .. \
    # && rm 3.4.14.zip \
    && rm -rf opencv-3.4.14

RUN apt update && apt install -q -y --no-install-recommends \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz \
    && tar -xvf ceres-solver-1.14.0.tar.gz \
    && mkdir ceres-bin \
    && cd ceres-bin \
    && cmake ../ceres-solver-1.14.0 \
    && make -j3 \
    && make test \
    && make install

RUN apt update && apt install -q -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl || true \
    && apt install -q -y --no-install-recommends libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.8.1.tar.gz \
    && tar xvf pcl-1.8.1.tar.gz \
    && cd pcl-pcl-1.8.1 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j4 \
    && make install
    # && cd ../.. \
    # && rm pcl-1.8.1.tar.gz \
    # && rm -rf pcl-pcl-1.8.1

RUN add-apt-repository --remove ppa:v-launchpad-jochen-sprickerhof-de/pcl \
    && apt update && apt install -q -y --no-install-recommends \
    ros-melodic-cv-bridge \
    ros-melodic-pcl-conversions \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c 'mkdir -p /catkin_ws/src \
    && cd /catkin_ws/src \
    && git clone https://github.com/hku-mars/mlcc.git \
    && cd .. \
    && source /opt/ros/melodic/setup.bash \
    && catkin_make'
    # && source /catkin_ws/devel/setup.bash

COPY startup.sh /
ENTRYPOINT ["/startup.sh"]