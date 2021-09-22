# Singularity-recipe-template for building Deepspeed-enabled pytorch-container 
## Install singularity
Follow these instructions to install singularity on a system
    https://sylabs.io/guides/3.3/user-guide/installation.html

## Building a container

You need root-privileges (or --fakeroot) to build containers. (In my undest
You may need to set cachedir for singularity to avoid 'disk is full'-errors

`export SINGULARITY_TMPDIR=/path/ e.g /$HOME/.cache/singularity`

**BUILD:** `sudo singularity build container-name Singularity`

## Running on CSC-environment

If running on Mahti make sure your $HOME/.ssh/config is looking like this
```
    host c???? g???? mahti* *.mahti.csc.fi
      IdentityFile ~/.ssh/id_rsa_mahti
      StrictHostKeyChecking no
```   
      
Put the following inside your slurm-script:

```
#Load pdsh
module load pdsh/2.31

#Bind directory with pdsh to /usr/local/sbin in singularity
export SING_FLAGS="$SING_FLAGS -B /appl/spack/v014/install-tree/gcc-4.8.5/pdsh-2.31-cdzt5w/bin:/usr/local/sbin"`

export SING_IMAGE=/PATH/TO/CONTAINER/deepspeed.sif #This needs to match the path inside your init_node.sh
export SING_FLAGS=$SING_FLAGS "--nv" # Enable GPU
export TORCH_EXT_DIR=/path/to/some/dir/ #I f you have existing dir with some ops, may cause a hang with a msg about using this torch_ext_dir. Try removing that dir and run your job again.
```

**RUNNING:**
  `singularity_wrapper exec deepspeed DEEPSPEED_ARGUMENTS path/to/python_script.py PYTHON_ARGUMENTS`

**EXAMPLE:**
  ```singularity_wrapper exec deepspeed --hostfile=hostfile.txt --master_addr=$MASTER_NODE /projappl/project_2004600/risto/model3multi/training/trainer.py --train_data $TRAIN_DATA \ ... ```




## Notes
This version has been configured to use pdsh for inter-node communications. No other runners have been tested and may need spesific configurations. 
PDSH-runner has been modified to contain relevant information about running python inside container: 
1) added line "source node_init.sh" *see node_init.sh*
2) exec argument `python` changed to `singularity_wrapper exec python`
File is located at`/opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py`
