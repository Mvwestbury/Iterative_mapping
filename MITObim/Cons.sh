## Example run sh /groups/hologenomics/westbury/data/Iterative_mapper/Scripts/Cons.sh Emeus 1 Casuarius SSdam_10x /groups/hologenomics/westbury/data/Iterative_mapper/Mapping/Casuarius/MITObim/10x/SS /groups/hologenomics/westbury/data/Iterative_mapper/Mapping/Casuarius/MITObim/10x/Consensuses
## $1 Sample code
## $2 Output directory
## $3 Starting directory
## $4 Base directory


cd $4
iter=$(ls -d $3/iteration* | sort -r | head -1)
cp $iter/*assembly/*results/$1-*_$1.unpadded.fasta $2
cd $4
