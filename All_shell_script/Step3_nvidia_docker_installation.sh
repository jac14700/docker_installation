#!/bin/bash
cd ~/Downloads
chmod 755 cuda_9.1.85_387.26_linux.run
sudo ./cuda_9.1.85_387.26_linux.run –override
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo apt-get install -y nvidia-docker2=2.0.3+docker18.09.4-1 nvidia-container-runtime=2.0.0+docker18.09.4-1

docker run --runtime=nvidia -it --rm tensorflow/tensorflow:latest-gpu \
   python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"
 docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook:9b06df75e445
