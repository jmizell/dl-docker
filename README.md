## Python Machine Learning Container

* Ubuntu 14.04
* Python 2.7
* Ngrok
* Tmux
* [CUDA 8](https://developer.nvidia.com/cuda-toolkit)
* [cuDNN v5](https://developer.nvidia.com/cudnn)
* [Tensorflow](https://www.tensorflow.org/)
* [Theano](http://deeplearning.net/software/theano/)
* [Keras](http://keras.io/)
* [iPython/Jupyter Notebook](http://jupyter.org/) (including iTorch kernel)
* [Numpy](http://www.numpy.org/), [SciPy](https://www.scipy.org/), [Pandas](http://pandas.pydata.org/), [Scikit Learn](http://scikit-learn.org/), [Matplotlib](http://matplotlib.org/)

## Using this container
You need a working install of Nvidia-Docker

```
docker run \
  -it \
  --rm \
  -p 222:22 \
  -p 8888:8888 \
  jmizell/ml-python:latest
```

### Environment Variables

* SHELL_PASSWORD: specify the ssh password for the root user
* NGROK_AUTH: ngrok auth token. If this variable is set ngrok will expose the ssh daemon on a public tunnel.
  Check the container log for this value.

## Building this container

```
docker build -t ml-python .
```
