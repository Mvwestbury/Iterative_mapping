## $1 - Threads
## $2 - Raw reads folder
## $3 - Code name for sample
## $4 - Results folder
## $5 - Reference
## $6 - Ref name

# 5 ~/data/Iterative_mapper/Simulations/Crocuta/Trimmed_reads/Crocuta_DSdam_40x_merged_renamed.fastq Crocuta_DSdam_40x ~/data/Iterative_mapper/Mapping/Crocuta/aITE/DS /groups/hologenomics/westbury/data/Iterative_mapper/Mapping/Crocuta/References/Hyaena_mito.fasta Hyaena 

for num in 10 20 30
do
rm -r $4/$6_mapq${num} 
mkdir $4/$6_mapq${num} 
sh /groups/hologenomics/westbury/data/Iterative_mapper/Scripts/aITE_mapper.sh $1 $2 $3 $4/$6_mapq${num} $5 $6 ${num}
done
