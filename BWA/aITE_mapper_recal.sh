## Ancient data processing and mapping using aln
## $1 - Threads
## $2 - Raw reads folder
## $3 - Code name for sample
## $4 - Results folder
## $5 - Reference
## $6 - Ref name
## $7 - Minmappingq

bwa index $5

### Map reads R1 with BWA, parse output through SAMtools (index ref file first)
bwa aln -l 999 -n 0.001 -o 2 -t $1 $5 $2 | bwa samse $5 - $2 | samtools view -F 4 -q $7 -@ $1 -uS - | samtools sort -@ $1 -o $4/$3.sort.bam

## Remove duplicates sort and index bam
samtools rmdup -S $4/$3.sort.bam $4/$3.rmdup.bam
samtools sort -@ $1 $4/$3.rmdup.bam -o $4/$3.1.rmdup.sort.bam
samtools index $4/$3.1.rmdup.sort.bam
rm $4/$3.sort.bam $4/$3.rmdup.bam

## reads, coverage, bp mapped, Ns
samtools view -c $4/$3.1.rmdup.sort.bam >> $4/$3_$6.records.txt
samtools depth -a $4/$3.1.rmdup.sort.bam | awk '{sum+=$3;cnt++}END{print sum/cnt "\t" sum}' >> $4/$3_$6.records.txt
samtools depth -a $4/$3.1.rmdup.sort.bam | awk '$3==0{print}' | wc -l >> $4/$3_$6.records.txt
mapDamage -i $4/$3.1.rmdup.sort.bam --merge-reference-sequences --rescale -r $5 -d $4/mapdamage --rescale-out=$4/$3.1.rmdup.sort_recal.bam

for num in {1..100}
do
samtools index $4/$3.${num}.rmdup.sort_recal.bam 
angsd -dofasta 3 -minq 30 -minmapq $7 -i $4/$3.${num}.rmdup.sort_recal.bam -out $4/$3_$6.con.${num} -docounts 1 -setMinDepth 3
gunzip $4/$3_$6.con.${num}.fa.gz
bwa index $4/$3_$6.con.${num}.fa
NUM=$(echo ${num} | awk '{print $1+1}')
bwa aln -l 999 -n 0.001 -o 2 -t $1 $4/$3_$6.con.${num}.fa $2 | bwa samse $4/$3_$6.con.${num}.fa - $2 | samtools view -F 4 -q $7 -@ $1 -uS - | samtools sort -@ $1 -o $4/$3.sort.bam
samtools rmdup -S $4/$3.sort.bam $4/$3.rmdup.bam
samtools sort -@ $1 $4/$3.rmdup.bam -o $4/$3.${NUM}.rmdup.sort.bam
samtools index $4/$3.${NUM}.rmdup.sort.bam
rm $4/$3.sort.bam $4/$3.rmdup.bam $4/$3.${num}.rmdup.sort.bam*
mapDamage -i $4/$3.${NUM}.rmdup.sort.bam --merge-reference-sequences --rescale -r $4/$3_$6.con.${num}.fa -d $4/mapdamage --rescale-out=$4/$3.${NUM}.rmdup.sort_recal.bam
rm $4/$3_$6.con.${num}.arg $4/$3_$6.con.${num}.fa.*
samtools view -c $4/$3.${NUM}.rmdup.sort.bam >> $4/$3_$6.records.txt
samtools depth -a $4/$3.${NUM}.rmdup.sort.bam | awk '{sum+=$3;cnt++}END{print sum/cnt "\t" sum}' >> $4/$3_$6.records.txt 
samtools depth -a $4/$3.${NUM}.rmdup.sort.bam | awk '$3==0{print}' | wc -l >> $4/$3_$6.records.txt

samtools view -c $4/$3.${num}.rmdup.sort_recal.bam > $4/mapped_reads.tmp
samtools view -c $4/$3.${NUM}.rmdup.sort_recal.bam > $4/mapped_reads2.tmp
N1=$(cat $4/mapped_reads.tmp)
N2=$(cat $4/mapped_reads2.tmp)
if [ $N1 = $N2 ]; then
echo Finished after ${num} iterations with $N1 reads mapping        
angsd -dofasta 3 -minq 30 -minmapq 30 -i $4/$3.${NUM}.rmdup.sort_recal.bam -out $4/$3_$6.con.${NUM}_final -docounts 1 -setMinDepth 3
break
fi

done

cat $4/$3_$6.records.txt |paste - - -  > $4/$3_$6.final_results.txt
