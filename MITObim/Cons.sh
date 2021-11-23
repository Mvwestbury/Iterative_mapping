## Example run sh /groups/hologenomics/westbury/data/Iterative_mapper/Scripts/Cons.sh Emeus 1 Casuarius SSdam_10x /groups/hologenomics/westbury/data/Iterative_mapper/Mapping/Casuarius/MITObim/10x/SS /groups/hologenomics/westbury/data/Iterative_mapper/Mapping/Casuarius/MITObim/10x/Consensuses
## $1 Ref code
## $2 mismatch
## $3 Species
## $4 suffix (e.g. DSdam_40x or SS
## $5 Starting directory
## $6 Output directory

cd $5
iter=$(ls -d $1_mismatch$2/iteration* | sort -r | head -1)
cd $iter/$3_$4-$1_$2perc_assembly/$3_$4-$1_$2perc_d_results
miraconvert $3_$4-$1_$2perc_out.maf $3_$4-$1_$2perc_out.sam
samtools view -F 4 -q 30 -@ 5 -uS $3_$4-$1_$2perc_out.sam | samtools sort -@ 5 -o $3_$4_$1_$2perc_mbim.bam
angsd -dofasta 3 -minq 30 -minmapq 30 -i $3_$4_$1_$2perc_mbim.bam -out $6/$3_$4_$1_$2perc_mbim.final -docounts 1 -setMinDepth 3
cd $5
