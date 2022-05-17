### Analyzing the RNASeq data
printf "\n!!!!!!! \nHi Jerry, a new journey of paired-end RNA-seq analysis has began.\n!!!!!!!\n\n"

# mkdir BAM Statistics Tracks

#infile=(2022_N2a_siRNA_ctrl_totalRNA_Rep1)
infile=(2022_N2a_siRNA_ctrl_totalRNA_Rep2 2022_N2a_siRNA_ctrl_totalRNA_Rep3 2022_N2a_siRNA_siHs6st1_totalRNA_Rep1 2022_N2a_siRNA_siHs6st1_totalRNA_Rep2 2022_N2a_siRNA_siHs6st1_totalRNA_Rep3 2022_N2a_siRNA_siFgfr1_totalRNA_Rep1 2022_N2a_siRNA_siFgfr1_totalRNA_Rep2 2022_N2a_siRNA_siFgfr1_totalRNA_Rep3 2022_N2a_siRNA_siFgfr1_totalRNA_Rep4)

for inputname in "${infile[@]}"
do
    cd "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/FASTQ"
    #### Step 1: mapping use STAR
    echo "\n\n\n\nWorking on sample ${inputname}  \n\n"
    printf "\n\n\n  Step 1 of 3: STAR mapping \n\n"
  
    mkdir "tmp1" ## map the temp directory for mapping
    mv "${inputname}_1.fastq" "tmp1" ## move FASTQ to the folder
    mv "${inputname}_2.fastq" "tmp1" ## move FASTQ to the folder
    cd "tmp1"

    STAR --genomeDir "/Users/jerry/Analysis/Genome/STAR/mm10" --readFilesIn "${inputname}_1.fastq" "${inputname}_2.fastq" --runThreadN 40 --outFilterMultimapNmax 1 --outFilterMismatchNmax 3 --outFilterScoreMinOverLread 0.25 --outFilterMatchNminOverLread 0.25

    samtools view -f 0x2 "Aligned.out.sam" -o "${inputname}_pair.sam" ## remove singletons
    samtools view -H "Aligned.out.sam" -o "header.sam"  ## SAM headers 
    cat "header.sam" "${inputname}_pair.sam" > "${inputname}.sam" 
    mv "Log.final.out" "${inputname}.Log" ## rename the mapping statistics file
    head -n 50 "${inputname}.Log" ## the mapping statistics

    mv "${inputname}.sam" "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/BAM"
    mv "${inputname}_1.fastq" ".."
    mv "${inputname}_2.fastq" ".."
#    rm "${inputname}_1.fastq"
#    rm "${inputname}_2.fastq"
    mv "${inputname}.Log" "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Statistics"

    cd ".."
    rm -rf "tmp1"
    gzip "${inputname}_1.fastq"
    gzip "${inputname}_2.fastq"
 


    #### Step 2: split the SAM file by chromosome 
    printf "\n\n\nStep 2 of 3: split sam by chromosome \n\n"
    cd "/Users/jerry/Analysis/Split"
    gawk -v tag=${inputname} 'NR>25 { print > tag".sam.chr"$3}' "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/BAM/${inputname}.sam"



    #### Step 3: Generate bam and BigWig file from sam file
    printf "\n\n\nStep 3 of 3: generate bam and BigWig from SAM file \n\n"
    cd "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/BAM"
    # sam to bam
    samtools view -bS "${inputname}.sam" -o  "${inputname}_raw.bam" ## convert sam to bam
    samtools sort "${inputname}_raw.bam" -o "${inputname}.bam"      ## sort ba
    samtools index "${inputname}.bam"                               ## index bam
    rm "${inputname}_raw.bam"                                       ## remove unsorted bam

    # bam to BigWig
    lines=`expr $(wc -l < "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/BAM/${inputname}.sam"| tr -d " ") - 25` ## uniquely mapped reads
    bw_value=`expr $lines / 2000000` ### The normalized bw y-axes will be uniquely mapped read-pairs (Million)

    bamCoverage -b "${inputname}.bam" --filterRNAstrand forward --binSize 1 -p 14 -o "${inputname}_plus_${bw_value}.bw" 
    bamCoverage -b "${inputname}.bam" --filterRNAstrand reverse --binSize 1 -p 14 -o "${inputname}_minus_${bw_value}.bw"
    mv "${inputname}_plus_${bw_value}.bw" "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Tracks" 
    mv "${inputname}_minus_${bw_value}.bw" "/Users/jerry/Analysis/Project/siRNA_Hs6st1_Fgfr1/Tracks"

#    rm "${inputname}.sam"
done

