BootStrap: docker
From: nvcr.io/nvidia/pytorch:21.08-py3

%setup
  TMPDIR=home/runner/work/cache/
  mkdir $TMPDIR
  export SINGULARITY_TMPDIR=$TMPDIR
  export SINGULARITY_CACHEDIR=$TMPDIR
%post
  /opt/conda/bin/pip install --upgrade pip 
  /opt/conda/bin/pip install --upgrade  setuptools
  /opt/conda/bin/pip install  git+https://github.com/huggingface/transformers
  /opt/conda/bin/pip install  datasets
  /opt/conda/bin/pip install  ninja
  /opt/conda/bin/pip install  triton
  export DS_BUILD_CPU_ADAM=1
  export DS_BUILD_FUSED_ADAM=1
  export DS_BUILD_FUSED_LAMB=1
  export DS_BUILD_SPARSE_ATTN=1
  export DS_BUILD_TRANSFORMER=1
  export DS_BUILD_TRANSFORMER_INFERENCE=0 
  export DS_BUILD_STOCHASTIC_TRANSFORMER=1
  export DS_BUILD_UTILS=1
  export DS_BUILD_AIO=0 

  /opt/conda/bin/pip install deepspeed --global-option="build_ext"
  /opt/conda/bin/conda clean -a
  perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity_wrapper exec python",\n/' /opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py
  sudo df -h
  sudo du -h --max-depth=1
