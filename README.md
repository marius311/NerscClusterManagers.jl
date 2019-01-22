# NerscClusterManagers.jl

This package facilitates setting up a parallel Julia environment at [NERSC](https://nersc.gov) Cori with a Jupyter notebook as a front end. 

Once set up, you will have a Jupyter notebook accessible from your local browser, which is controlling Julia workers running on the Cori compute nodes.  

## Installation

```julia
pkg> add https://github.com/marius311/NerscClusterManagers.jl
```

## Instructions

* Log in to [jupyter-dev.nersc.gov](https://jupyter-dev.nersc.gov)
* Create a new Julia notebook (v1.0+ required)
* Run the following in a cell in the notebook:
    ```julia
    using NerscClusterManagers
    em = ElasticManager(Val(:nersc))
    ```
    This will set up the master process and print a line which tells you how to connect workers, e.g. (this will be different every time so don't use this example):
    ```
    To connect workers:
    julia -e 'using ClusterManagers; ClusterManagers.elastic_worker("sgFIRyqWqpJX0RaR","128.55.224.49",12345)'
    ```
* Now from a separate terminal, log into Cori and submit an interactive job, e.g.:
    ```bash
    # request 5 nodes
    salloc -N 5 -C haswell --qos=interactive -t 04:00:00
    ```
* From this job, `srun` the worker command with the desired number of workers, compatible with the number of nodes you requested, e.g.
    ```bash
    # running 10 workers, two per node
    srun -n 10 -c 32 julia -e 'using ClusterManagers; ClusterManagers.elastic_worker("sgFIRyqWqpJX0RaR","128.55.224.49",12345)'
    ```
    
* Go back to the Jupyter notebook and evaluate `em`. You should see the new workers connected:
    ```
    ElasticManager:
      Active workers : [2,3,4,5,6,7,8,9,10,11]
      Number of workers to be added  : 0
      Terminated workers : []
    ```
    (more workers can be added at a later time too). 
* You can now use standard Julia parallel constructs like `@parallel` or `pmap`, and work will be distributed among your workers.
