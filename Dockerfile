FROM nvcr.io/nvidia/pytorch:21.09-py3 

RUN /opt/conda/bin/pip install --upgrade pip &&  /opt/conda/bin/pip install --upgrade  setuptools && \ 
    /opt/conda/bin/pip install  git+https://github.com/huggingface/transformers datasets ninja triton pytorch-lightning

ENV DS_BUILD_CPU_ADAM=1 DS_BUILD_FUSED_ADAM=1  DS_BUILD_FUSED_LAMB=1 DS_BUILD_SPARSE_ATTN=0 DS_BUILD_TRANSFORMER=0 \
    DS_BUILD_TRANSFORMER_INFERENCE=0 DS_BUILD_STOCHASTIC_TRANSFORMER=0  DS_BUILD_UTILS=1 DS_BUILD_AIO=0 

RUN /opt/conda/bin/pip install deepspeed && \
    /opt/conda/bin/pip install --upgrade numpy

RUN    perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity exec $SING_FLAGS $SING_IMAGE python",\n/' /opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py

