Nvidia Docker installation 
=======
這份Readme是從零開始，安裝Ubuntu 18.04到docker的安裝、使用及開放外部使用者可以使用ipvr實驗室虛擬機的port在CUDA下以加速完成你要執行的任務

# 1.	先裝好Ubuntu如下網站所示
先製作Live USB隨身碟的軟體Unetbootin，如下網站所示

https://blog.xuite.net/yh96301/blog/57645340-Ubuntu+18.04%E8%A3%BD%E4%BD%9CLive+USB%E9%9A%A8%E8%BA%AB%E7%A2%9F%E7%9A%84%E8%BB%9F%E9%AB%94Unetbootin

以USB安裝Ubuntu的步驟

教學網站

https://blog.xuite.net/yh96301/blog/242333268

裝好後請記得 reboot 謝謝

# 2. Ubuntu 18.04 安裝NVIDIA驅動程式

http://chiustin.blogspot.com/2019/01/ubuntu-1804-nvidia.html

安裝前的套件

```shell
sudo apt-get install gcc
sudo apt-get install make
```
下面這行用以退出可能正在使用GPU的任何程序，才能進行安裝nvidia-driver

```shell
sudo service gdm3 stop
```

若沒執行可能會在安裝時出錯，如下

```shell
ERROR: An NVIDIA kernel module 'nvidia-drm' appears to already be loaded in your kernel.
This may be because it is in use (for example, by an X server, a CUDA program, or the NVIDIA Persistence Daemon), 
but this may also happen if your kernel was configured without support for module unloading.
Please be sure to exit any programs that may be using the GPU(s) before attempting to upgrade your driver.
If no GPU-based programs are running, you know that your kernel supports module unloading, 
and you still receive this message, then an error may have occured that has corrupted an NVIDIA kernel module's usage count, 
for which the simplest remedy is to reboot your computer.
```
記得重新啟動你的裝置
```shell
reboot
```
安裝驅動

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa 
sudo apt-get update
sudo apt-get install nvidia-driver-418
sudo service gdm3 start
reboot
```
![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/ubuntu%20driver-device.png)


進入桌面，執行下面的命令，查看驅動的安裝狀態
```shell
sudo nvidia-smi
```
若有安裝成功應該出現以下畫面

![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/nvidia-smi.png)


# 3.CUDA installation

先上Cuda官網安裝toolkit(請記得選擇是當的OS系統，如下，但請看你真實的系統)
https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1704&target_type=runfilelocal
![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/CUDA.jpg)

接下來，如下網站進行裏頭的三行指令，cuda_9.1這邊要自己更動
https://mark-down-now.blogspot.com/2018/05/pytorch-gpu-ubuntu-1804.html?fbclid=IwAR1clPJPvKOX0po0NkaL0rs96dH9Vv9gKQhmmSKGg-YpI0w9WzRsxMebgl4

只取這三行執行
```shell
cd ~/Downloads
chmod 755 cuda_9.1.85_387.26_linux.run
sudo ./cuda_9.1.85_387.26_linux.run –override
```
# 4.Docker 安裝( 含NVIDIA-docker )& 測試 NVIDIA-docker上的GPU 
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04?fbclid=IwAR3D4T707CRGAX-iIL0OEUoZD8b4u3V-czKF8wPrfFkTCkJCCgN2EfEL4pY


Step 1 — 安裝 Docker
```shell
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
```
![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/3.jpg)

Step 2 — Install nvidia-docker
```shell
sudo apt-get install -y nvidia-docker2=2.0.3+docker18.09.4-1 nvidia-container-runtime=2.0.0+docker18.09.4-1

sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/docker%20nvidia-smi.png)

測試Nvidia-docker有沒有辦法連到gpu實際運算

```shell
docker run --runtime=nvidia -it --rm tensorflow/tensorflow:latest-gpu \
   python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"
```

跑出來的結果
![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/gpu_connect_test.png)

開一個對外的port，讓外部用戶可以連進140.115.59.124 的一個docker image來訓練資料或是進行其他計算複雜的程式
```shell
sudo docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook:9b06df75e445
```
開啟之後輸出應該長這樣

![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/key_token.png)

開啟網頁在網址上打入 sever端IP:port ，我們的IP是140.115.59.124 ，剛剛開啟的port是10000 ，如下圖

password 可以貼token
![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/jupyter_enterance.png)

進入後應如下

![image](https://github.com/ncuipvr/RoadToHell/blob/master/im/jupyterLab.png)
