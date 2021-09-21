Bootstrap: library
From: centos:7.7

%labels
  Author Mats Sjöberg <mats.sjoberg@csc.fi>

%files
  requirements_pytorch_1.8.txt /opt/requirements.txt
  libcudnn8*.x86_64.rpm /opt/rpms/

%post
  # Upgrade packages to most recent versions
  yum -y upgrade

  # Enable EPEL (required by NVIDIA packages)
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

  # Install newer gcc and Python 3.8
  yum -y install centos-release-scl
  yum -y install devtoolset-7
  yum -y install rh-python38
  yum -y install rh-python38-python-devel
  yum -y install rh-git218
  source /opt/rh/devtoolset-7/enable
  source /opt/rh/rh-python38/enable
  source /opt/rh/rh-git218/enable

  # Install additional stuff
  yum -y install wget cmake lbzip2 libsndfile

  # Install Mellanox stuff and OpenMPI
  wget https://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox
  rpm --import RPM-GPG-KEY-Mellanox
  rm RPM-GPG-KEY-Mellanox

  cd /etc/yum.repos.d/
  # MOFED 4.7
  # wget https://linux.mellanox.com/public/repo/mlnx_ofed/4.7-1.0.0.1/rhel7.7/mellanox_mlnx_ofed.repo
  # MOFED 5.0
  wget https://linux.mellanox.com/public/repo/mlnx_ofed/5.0-1.0.0.0/rhel7.8/mellanox_mlnx_ofed.repo
  yum -y install mlnx-ofed-all

  # Install CUDA
  cd /etc/yum.repos.d/
  wget https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
  yum -y install nvidia-driver-latest-dkms cuda-11-1
  yum -y install cuda-drivers

  # Install CUDNN
  # Has to be manually downloaded from here: https://developer.nvidia.com/cudnn
  rpm -i /opt/rpms/libcudnn8*.rpm
  rm /opt/rpms/libcudnn8*.rpm

  # Install NCCL
  yum -y install libnccl-2.8.4-1+cuda11.1 libnccl-devel-2.8.4-1+cuda11.1 libnccl-static-2.8.4-1+cuda11.1

  python -m pip install --upgrade --user pip
  python -m pip install --upgrade --user setuptools
  python -m pip install --upgrade --user wheel
  python -m pip install chardet
 # Install PyTorch
  pip install torch==1.9.0+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 torchtext==0.9.1 \
      -f https://download.pytorch.org/whl/torch_stable.html \
      -r /opt/requirements.txt
    
  python -m pip install  git+https://github.com/huggingface/transformers
  python -m pip install ninja
  python -m pip install triton
  export DS_BUILD_CPU_ADAM=1
  export DS_BUILD_FUSED_ADAM=1
  export DS_BUILD_FUSED_LAMB=1
  export DS_BUILD_SPARSE_ATTN=1
  export DS_BUILD_TRANSFORMER=1
  export DS_BUILD_TRANSFORMER_INFERENCE=0 
  export DS_BUILD_STOCHASTIC_TRANSFORMER=1
  export DS_BUILD_UTILS=1
  export DS_BUILD_AIO=0 
  python -m pip install deepspeed --global-option="build_ext"
  perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity_wrapper exec python",\n/' /opt/rh/rh-python38/root/usr/local/lib64/python3.8/site-packages/deepspeed/launcher/multinode_runner.py
  export OMPI_DIR=$(ls -1d /usr/mpi/gcc/openmpi-4.0.* | head -n1)
  export PATH=$OMPI_DIR/bin:$PATH
  export LD_LIBRARY_PATH=$OMPI_DIR/lib64:$LD_LIBRARY_PATH

  export PATH=/usr/local/cuda/bin:$PATH
  
  yum clean all

%environment
  export SLURM_MPI_TYPE=pmix_v2
  export PMIX_MCA_gds=hash

  export OMPI_DIR=$(ls -1d /usr/mpi/gcc/openmpi-4.0.* | head -n1)
  export PATH=/usr/local/cuda/bin:$OMPI_DIR/bin:$PATH
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$OMPI_DIR/lib64:$LD_LIBRARY_PATH

  source /opt/rh/devtoolset-7/enable
  source /opt/rh/rh-python38/enable
  source /opt/rh/rh-git218/enable
