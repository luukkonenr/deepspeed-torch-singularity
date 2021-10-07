FROM nvcr.io/nvidia/pytorch:21.09-py3 
RUN  /opt/conda/bin/pip install --upgrade pip
RUN  /opt/conda/bin/pip install --upgrade  setuptools
RUN  /opt/conda/bin/pip install  git+https://github.com/huggingface/transformers
RUN  /opt/conda/bin/pip install  datasets
RUN  /opt/conda/bin/pip install  ninja
RUN  /opt/conda/bin/pip install  triton
RUN  export DS_BUILD_CPU_ADAM=1
RUN  export DS_BUILD_FUSED_ADAM=1
RUN  export DS_BUILD_FUSED_LAMB=1
RUN  export DS_BUILD_SPARSE_ATTN=1
RUN  export DS_BUILD_TRANSFORMER=1
RUN  export DS_BUILD_TRANSFORMER_INFERENCE=0
RUN  export DS_BUILD_STOCHASTIC_TRANSFORMER=1
RUN  export DS_BUILD_UTILS=1
RUN  export DS_BUILD_AIO=0

RUN  /opt/conda/bin/pip install deepspeed --global-option="build_ext"

RUN  perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity_wrapper exec python",\n/' /opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py

