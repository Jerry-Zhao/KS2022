#! /usr/local/perl -w
## Jerry's ChIP-seq pipeline
## Needed: bowtie  samtools  deepTools
## bowtie-build ../../Mus_musculus.GRCm38.93.mm10.fa mm10

## Needed: Location of the Bowtie-genome folder
$bowtie_genome="/Users/jerry/Analysis/Genome/Bowtie/mm10";

print "!!!!!!!\nHi Jerry, a new journey of ChIP-seq analysis has began.\n\n";
print "Please enter the input FASTQ file: donot need '.fastq'\n";
chomp($name=<STDIN>);


print "\n\nbowtie -v 2 -m 1 -p 40\n";
print "Bowtie mapping
   -v 2: up to two mismatch
   -m 1: only report reads that mapped once 
   -p 40: using 40 processors
\n\n";


print "\n\n Working on the bowtie mapping.\n";
system ("bowtie -v 2 -m 1 -p 40 -x $bowtie_genome -q $name.fastq -S $name.sam");


print "\n\nWorking on removing the unmapped reads.\n";
open(INA,"$name.sam")||die("Can't open INA: $name.sam $!\n");
open(OUA,">$name\_uniq.sam")||die("Can't write OUA:$!\n");

while(<INA>)
{
 chomp;
 $a1++;
 if(/^@/){print OUA "$_\n";$a2++;}
 elsif(/^([\w\.\-\:\/\#]+)\t\d+\t\w+\t/)
 {
  $a3++; $a4++;
  print OUA "$_\n";
 }
 elsif(/^([\w\.\-\:\/\#\s]+)\t4\t\*\t0/)
 {
  $a3++; $a7++;
 }
 else{print "error1\t$_\n";}
}

print "Total-Bowtie output: $a1\t title-lines: $a2\n";
print "Total-reads: $a3\n";
print "Unique-mapped: $a4\n";
print "Un-mapped: $a7\n";

close INA;
close OUA;

system("rm $name.sam");

print "\n\n\nWorking on the samtools.\n";
system("samtools view -bS $name\_uniq.sam >$name.bam");
system("samtools sort $name.bam -o $name\_sort.bam");
system("samtools index $name\_sort.bam");


my $uniquemapper=`wc -l < $name\_uniq.sam`; ## get the uniquely mapped read number(including 24 header lines)
$bw_value=int(($uniquemapper - 24)*5/1000000);



print "\n\nWorking on the bamCoverage to generate bw file.\n\n";
system("bamCoverage -b $name\_sort.bam -o $name\_$bw_value.bw --binSize 10 -p 40 --extendReads 250");

print "\n\nWorking on the bamCoverage to generate bedgraph file.\n\n";
system("bamCoverage -b $name\_sort.bam -o $name\_$bw_value.bg -of bedgraph --binSize 10 -p 40 --extendReads 250");

# system("gzip $name.fastq");
system("rm $name\_uniq.sam");
system("rm $name.bam");
system("rm $name\_sort.bam.bai");

print "\n\n\nCongratulation, Jerry. \nYou have finished the ChIP-seq analysis for file $name.fastq\nGo get a beer.\n";

