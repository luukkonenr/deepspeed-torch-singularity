FROM nvcr.io/nvidia/pytorch:21.09-py3 

RUN /opt/conda/bin/pip install --upgrade pip &&  /opt/conda/bin/pip install --upgrade  setuptools && \
    /opt/conda/bin/pip install  git+https://github.com/huggingface/transformers datasets ninja triton 
ENV DS_BUILD_CPU_ADAM=1 DS_BUILD_FUSED_ADAM=1  DS_BUILD_FUSED_LAMB=1 DS_BUILD_SPARSE_ATTN=1 DS_BUILD_TRANSFORMER=1 \
    DS_BUILD_TRANSFORMER_INFERENCE=0 DS_BUILD_STOCHASTIC_TRANSFORMER=1  DS_BUILD_UTILS=1 DS_BUILD_AIO=0 

RUN /opt/conda/bin/pip install deepspeed
    
RUN    perl -p -i -e 's/^\s*sys\.executable,\s*$/            "source node_init.sh;",\n            "singularity_wrapper exec python",\n/' /opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py

