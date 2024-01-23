## $1 - fastq files
## $2 - ID
## $3 - ref file
## $4 - ref ID
## $5 - results folder

for num in 0 1 3 5 10 15
do
rm -r $5/$4_mismatch${num}
mkdir $5/$4_mismatch${num}
cd $5/$4_mismatch${num}
MITObim -end 1000 -sample $2 -readpool $1 -ref $4_${num}perc --quick $3 --clean --mismatch ${num} > $2-$4_${num}perc.log
done
