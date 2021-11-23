
## Ancient data processing and mapping using aln
## $1 - Threads
## $2 - Raw reads folder
## $3 - Code name for sample
## $4 - Results folder
## $5 - Reference

### Index the reference (prepare for mapping)
bwa index $5 

### Map reads R1 with BWA, parse output through SAMtools (index ref file first)
bwa aln -l 999 -n 0.04 -t $1 $5 $2 | bwa samse $5 - $2 | samtools view -F 4 -q 30 -@ $1 -uS - | samtools sort -@ $1 -o $4/$3.sort.bam

## Remove duplicates sort and index bam
samtools rmdup -S $4/$3.sort.bam $4/$3.rmdup.bam
samtools sort -@ $1 $4/$3.rmdup.bam -o $4/$3.rmdup.sort.bam
samtools index $4/$3.rmdup.sort.bam
angsd -dofasta 3 -minq 30 -minmapq 30 -i $4/$3.rmdup.sort.bam -out $4/$3.con.final -docounts 1 -setMinDepth 3

## Coverage and bp mapped
samtools depth -a $4/$3.rmdup.sort.bam | awk '{sum+=$3;cnt++}END{print sum/cnt "\n" sum}' >> $4/$3_records.txt

## how many reads mapped post duplicate removal to mito
samtools view -c $4/$3.rmdup.sort.bam >> $4/$3_records.txt

