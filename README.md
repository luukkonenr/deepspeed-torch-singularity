# Singularity-recipe-template for building Deepspeed-enabled pytorch-container 
## Install singularity
Follow these instructions to install singularity on a system
    https://github.com/hpcng/singularity/blob/master/INSTALL.md

NOTE: I've used **Singularity version 3.5.3**, newest 3.8.3 gave me some errors and I think it uses later gcc or something like that which results in build problems with some of the libraries.

## Option 1: Building a container on your own machine

You need root-privileges (or --fakeroot) to build containers.
You may need to set cachedir for singularity to avoid 'no space left on device'-errors

```
mkdir $HOME/.cache/singularity/
export SINGULARITY_TMPDIR=/path/ e.g $HOME/.cache/singularity/
export SINGULARITY_CACHEDIR=/path/ e.g $HOME/.cache/singularity/
```
**BUILD:** `sudo -E singularity build container-name Singularity`

## Option 2: Pulling ready-built image from ghcr
```
export SINGULARITY_TMPDIR=/path/ e.g $HOME/.cache/singularity/
export SINGULARITY_CACHEDIR=/path/ e.g $HOME/.cache/singularity/
singularity pull NAME_FOR_IMG docker://ghcr.io/luukkonenr/deepspeed-torch-singularity:latest
 ```
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

export SING_IMAGE=/PATH/TO/CONTAINER/deepspeed.sif # This needs to match the path inside your init_node.sh
export SING_FLAGS=$SING_FLAGS "--nv" # Enable GPU
export TORCH_EXT_DIR=/path/to/some/dir/ # I f you have existing dir with some ops, may cause a hang with a msg about using this torch_ext_dir. Try removing that dir and run your job again.
```

**RUNNING:**
  `singularity_wrapper exec deepspeed DEEPSPEED_ARGUMENTS path/to/python_script.py PYTHON_ARGUMENTS`

**EXAMPLE:**
  ```singularity_wrapper exec deepspeed --hostfile=hostfile.txt --master_addr=$MASTER_NODE /projappl/project_2004600/risto/model3multi/training/trainer.py --train_data $TRAIN_DATA \ ... ```




## Changes to packages:
This version has been configured to use pdsh for inter-node communications. No other runners have been tested and may need spesific configurations. 
`/opt/conda/lib/python3.8/site-packages/deepspeed/launcher/multinode_runner.py` has been modified to contain relevant information about running python inside the container: 
1) added line "source node_init.sh" *see node_init.sh* to PDSH-runner-class
2) exec argument `python` changed to `singularity_wrapper exec python` to PDSH-runner-class

## Notes
* **IMPORTANT**: If you have a local installation of deepspeed it may conflict with the one in singularity. Run the following and make sure your install path is identical. If path points to a local installation, you need to shadow it out by renaming the package e.g. ['/users/$USER/.local/lib/python3.8/site-packages/deepspeed'] -->['/users/$USER/.local/lib/python3.8/site-packages/DEEPSPEED'], delete it or do it some other way.
```
export SING_IMAGE=/PATH/TO/CONTAINER/deepspeed.sif 
singularity_wrapper exec ds_report 
deepspeed install path ........... ['/opt/conda/lib/python3.8/site-packages/deepspeed']
```

* I've tried to test get build process working with Github Actions but during build I encounter "no space left on device"-error and build crashes. Will try to get this working so newest img would always be ready to get pulled.




## Resources:
   * https://singularity-tutorial.github.io/ -- Basics of singularity usage
   * https://sylabs.io/guides/3.5/user-guide/ -- Singularity docs (v.3.5)
