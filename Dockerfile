# Generates a Qt Webassembly build environment
# Copyright Ryan Landvater, 2020
FROM ubuntu:18.04

RUN apt -y update \
    && apt -y upgrade

RUN apt install -y \
  git \
  g++ \
  libclang-dev \
  cmake \
  python \
  gperf \
  bison \
  flex 
  
#Emscripten layer
RUN cd / \
    && git clone https://github.com/emscripten-core/emsdk.git \
    && cd emsdk \
    && ./emsdk install 1.39.8-64bit \
    && ./emsdk activate 1.39.8-64bit \
    && . "/emsdk/emsdk_env.sh" >> $HOME/.bash_profile

#Qt 5 layer
RUN cd /emsdk \
    && . "/emsdk/emsdk_env.sh" >> $HOME/.bash_profile \
    && cd / \
    && git clone --branch=5.15 git://code.qt.io/qt/qt5.git \
    && cd qt5 \
    && ./init-repository \
    && ./configure -xplatform wasm-emscripten -nomake examples -nomake tests -opensource --confirm-license \
    && make module-qtbase module-qtdeclarative module-qtquick module-qtquickcontrols module-qtquicklayouts install\
