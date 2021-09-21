Bootstrap: docker
From: nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

%post
    # Downloads the latest package lists (important).
    apt-get update -y
    # Runs apt-get while ensuring that there are no user prompts that would
    # cause the build process to hang.
    # python3-tk is required by matplotlib.
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
        python3-tk \
        python3-pip \
        python3-setuptools
    # Reduce the size of the image by deleting the package lists we downloaded,
    # which are useless now.
    rm -rf /var/lib/apt/lists/*
    # Install Python modules.

  pip3 install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html &&

  pip3 install --upgrade  pip
  pip3 install --upgrade  setuptools
  pip3 install --upgrade  wheel
  pip3 install  transformers 
  pip3 install  datasets
  pip3 install  ninja
  pip3 install  triton
  export DS_BUILD_CPU_ADAM=1
  export DS_BUILD_FUSED_ADAM=1
  export DS_BUILD_FUSED_LAMB=1
  export DS_BUILD_SPARSE_ATTN=1
  export DS_BUILD_TRANSFORMER=1
  export DS_BUILD_TRANSFORMER_INFERENCE=0
  export DS_BUILD_STOCHASTIC_TRANSFORMER=1
  export DS_BUILD_UTILS=1
  export DS_BUILD_AIO=0
  pip3 install deepspeed --global-option="build_ext"

  perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity_wrapper exec python",\n/' /opt/rh/rh-python38/root/usr/local/lib64/python3.8/site-packages/deepspeed/launcher/multinode_runner.py
~
~

~
~
~
~
