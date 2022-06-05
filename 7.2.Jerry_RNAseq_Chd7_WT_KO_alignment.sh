#!/bin/bash 
### Analyzing the RNASeq data
printf "\n!!!!!!! \nHi Jerry, a new journey of single-end RNA-seq analysis has began.\n!!!!!!!\n\n"

## mkdir BAM Statistics Tracks

## head -n 40000 GSE164360_Cerebellum_P4_Chd7_KO_rep1.fastq >Test.fastq
## infile=(Test)

# infile=(GSE164360_Cerebellum_P4_Chd7_KO_rep1)
infile=(GSE164360_Cerebellum_P4_Chd7_KO_rep2 GSE164360_Cerebellum_P4_Chd7_KO_rep3 GSE164360_Cerebellum_P4_Chd7_KO_rep4 GSE164360_Cerebellum_P4_Chd7_KO_rep5 GSE164360_Cerebellum_P4_Chd7_WT_rep1 GSE164360_Cerebellum_P4_Chd7_WT_rep2 GSE164360_Cerebellum_P4_Chd7_WT_rep3 GSE164360_Cerebellum_P4_Chd7_WT_rep4 GSE164360_Cerebellum_P4_Chd7_WT_rep5)

for inputname in "${infile[@]}"
do
    cd "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Chd7/FASTQ"
    #### Step 1: mapping use STAR
    echo "\n\n\n\nWorking on sample ${inputname}  \n\n"
    printf "\n\n\n  Step 1 of 3: STAR mapping \n\n"
  
    mkdir "tmp1" ## map the temp directory for mapping
    mv "${inputname}.fastq" "tmp1" ## move FASTQ to the folder
    cd "tmp1"

    STAR --genomeDir "/Users/jerry/Analysis/Genome/STAR/mm10" --readFilesIn "${inputname}.fastq" --runThreadN 40 --outFilterMultimapNmax 1 --outFilterMismatchNmax 3 --outFilterScoreMinOverLread 0.25 --outFilterMatchNminOverLread 0.25

    mv "Aligned.out.sam" "${inputname}.sam" ## rename the alignment SAM file
    mv "Log.final.out" "${inputname}.Log" ## rename the mapping statistics file
    head -n 50 "${inputname}.Log" ## the mapping statistics

    mv "${inputname}.sam" "../../BAM"
    mv "${inputname}.fastq" ".."
#    rm "${inputname}.fastq"
    mv "${inputname}.Log" "../../Statistics"

    cd ".."
    rm -rf "tmp1"
#    gzip "${inputname}.fastq"



    #### Step 2: split the SAM file by chromosome 
    printf "\n\n\nStep 2 of 3: split sam by chromosome \n\n"
    cd "/Users/jerry/Analysis/Split"
    gawk -v tag=${inputname} 'NR>25 { print > tag".sam.chr"$3}' "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Chd7/BAM/${inputname}.sam"



    #### Step 3: Generate bam and BigWig file from sam file
    printf "\n\n\nStep 3 of 3: generate bam and BigWig from SAM file \n\n"
    cd "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Chd7/BAM"
    # sam to bam
    samtools view -bS "${inputname}.sam" -o  "${inputname}_raw.bam" ## convert sam to bam
    samtools sort "${inputname}_raw.bam" -o "${inputname}.bam"      ## sort ba
    samtools index "${inputname}.bam"                               ## index bam
    rm "${inputname}_raw.bam"                                       ## remove unsorted bam

    # bam to BigWig
    lines=`expr $(wc -l < "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Chd7/BAM/${inputname}.sam"| tr -d " ") - 25` ## uniquely mapped reads
    bw_value=`expr $lines / 1000000` ### The normalized bw y-axes will be uniquely mapped reads (Million)

    bamCoverage -b "${inputname}.bam" --binSize 1 -p 30 -o "${inputname}_${bw_value}.bw" 
    mv "${inputname}_${bw_value}.bw" "../Tracks" 

#    rm "${inputname}.sam"
done

