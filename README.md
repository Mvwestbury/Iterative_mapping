# Iterative_mapping
Scripts used to test the role of parameters and software in iteratively mapping aDNA mitochondrial genomes

The variables that need to be specified in each of the scripts are available at the tops of the respective scripts

## BWA default
A standard script to run BWA aln using default parameters, filtering with SAMtools, and consensus sequence build with kindel

- Ancient_mapping_defaultBWA.sh

## BWA ancient iterative mapping (aITE)

There are four different scripts based on the different parameters tested.
- aITE_mapper.sh is used with default mismatch but can be used with variable mapping quality filters - to loop through the different mapping qualities one can use the Loop_mapqtest.sh script

- aITE_mapperv2.sh has mismatch value n = 0.01 (as opposed to the 0.04 default)

- aITE_mapperv3.sh utilises the parameters -n 0.001 -o 2

All can be run relatively similarly and produce a final consensus called prefix_final.fa.gz



## MITObim

- MITObimming.sh will run mitobim with various mismatch values (0 1 3 5 10 15) - note you will need to specify the full paths for this to work

As it is a little annoying to get to the correct folder and create a consensus fasta when doing multiple MITObim runs, I created Cons.sh to do this relatively easily.
