FROM alpine:latest
ARG IMAGEMAGIC_VERSION=7.1.0-37
ARG ENABLE_UTILITIES="no"

RUN set -x -o pipefail \
    && apk update \
    && apk add --no-cache libltdl \
    && apk add --no-cache --virtual im-deps \
        gcc \
        make \
        libc-dev \
        libtool \
    && wget -O- https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${IMAGEMAGIC_VERSION}.tar.gz | tar xzC /tmp \
    && cd /tmp/ImageMagick-${IMAGEMAGIC_VERSION} \
    && ./configure \
        --disable-static \
        --disable-dependency-tracking \
        --enable-silent-rules \
        --disable-cipher \
        --disable-openmp \
        --disable-hdri \
        --disable-opencl \
        --disable-docs \
        --with-modules \
        --with-utilities=${ENABLE_UTILITIES} \
        --without-magick-plus-plus \
        --without-perl \
        --without-bzlib \
        --without-x \
        --without-zip \
        --without-zlib \
        --without-zstd \
        --without-apple-font-dir \
        --without-dps \
        --without-dejavu-font-dir \
        --without-fftw \
        --without-flif \
        --without-fpx \
        --without-djvu \
        --without-fontconfig \
        --without-freetype \
        --without-raqm \
        --without-gdi32 \
        --without-gslib \
        --without-fontpath \
        --without-gs-font-dir \
        --without-gvc \
        --without-heic \
        --without-jbig \
        --without-jpeg \
        --without-jxl \
        --without-lcms \
        --without-openjp2 \
        --without-lqr \
        --without-lzma \
        --without-openexr \
        --without-pango \
        --without-png \
        --without-raw \
        --without-rsvg \
        --without-tiff \
        --without-webp \
        --without-wmf \
        --without-xml \
    && make -j$(nproc) && make install \
    && cd $OLDPWD \
    && rm -rf /tmp/ImageMagick-${IMAGEMAGIC_VERSION} \
    && apk del --no-network --purge im-deps
