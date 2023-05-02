# pull base image
FROM ubuntu:bionic AS build
LABEL stage=intermediate
ARG FF_VER=shared

# install packaged dependencies
RUN apt-get update && [ "$FF_VER" = 'shared' ] && \
	apt-get -y install --no-install-recommends libavformat-dev libavcodec-dev libavutil-dev g++ make git || \
	apt-get -y install --no-install-recommends yasm wget g++ make git ca-certificates xz-utils && \
	rm -rf /var/lib/apt/lists/*

# copy code
ADD . /untrunc-src
WORKDIR /untrunc-src

# build untrunc
#RUN /usr/bin/g++ -o untrunc *.cpp -lavformat -lavcodec -lavutil
RUN /usr/bin/make FF_VER=$FF_VER && strip untrunc


# deliver clean image
FROM ubuntu:bionic
ARG FF_VER=shared

RUN apt-get update && [ "$FF_VER" = 'shared' ] && \
	apt-get -y install --no-install-recommends libavformat57 libavcodec57 libavutil55 python3-setuptools python3-pip ffmpeg && \
	rm -rf /var/lib/apt/lists/* || true
COPY --from=build /untrunc-src/untrunc /bin/untrunc

# copy code
COPY ./requirement.txt requirement.txt
RUN pip3 install -r requirement.txt

# 생략
# RUN useradd voicepassing
# USER voicepassing
