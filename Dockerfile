FROM homeassistant/home-assistant:latest

ARG OPENCV_VERSION=4.1.0
RUN apk add --no-cache \
        libwebp \
        ffmpeg-libs \
        libdc1394 \
        jasper-libs \
        zlib \
    && apk add --no-cache --virtual .build-dependencies \
        build-base \
        cmake \
        ncurses \
        linux-headers \
        ffmpeg-dev \
        libwebp-dev \
        libpng-dev \
        zlib-dev \
        libjpeg-turbo-dev \
        tiff-dev \
        jasper-dev \
        libdc1394-dev \
    && export MAKEFLAGS="-j$(nproc)" \
    && git clone --depth 1 -b ${OPENCV_VERSION} https://github.com/opencv/opencv \
    && cd opencv \
    && mkdir -p build \
    && cd build \
    && if [ "${BUILD_ARCH}" != "armhf" ] && [ "${BUILD_ARCH}" != "armv7" ]; then \
            cmake .. -DCMAKE_BUILD_TYPE=Release \
                -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF \
                -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF; \
        else \
            cmake .. -DCMAKE_BUILD_TYPE=Release \
                -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF \
                -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF \
                -DENABLE_NEON=OFF -DCPU_BASELINE_REQUIRE=""; \
        fi \
    && make -j$(nproc) \
    && make install \
    && apk del .build-dependencies \
    && rm -rf /usr/src/opencv

RUN pip3 install pymysql
