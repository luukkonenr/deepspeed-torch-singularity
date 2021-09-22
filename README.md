# Singularity-recipe-template for building Deepspeed-enabled pytorch-container 
Install singularity:
  https://github.com/sylabs/singularity/releases

## Building a container
You may need to set cachedir for singularity to avoid 'disk is full'-errors

export SINGULARITY_TMPDIR=/path/ e.g /$HOME/.cache/singularity

BUILD:
  sudo singularity build container-name Singularity

## Using a container
singularity exec container-name python test.py (exec a python script within a container)
singularity shell container-name (interactive shell)

## Notes
This version has been configured to use pdsh for inter-node communications. No other runners have been tested and may need spesific configurations. 
PDSH-runner has been modified to contain relevant information about running python inside container: 
1) added line "source node_init.sh" to export SING_IMG=/image/ and 
CSC_ENV_INIT='/appl/profile/zz-csc-env.sh 
2) exec argument "python" changed to "singularity_wrapper exec python".  
(/opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py.)
