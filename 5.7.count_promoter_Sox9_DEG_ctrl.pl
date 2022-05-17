#! /usr/local/perl -w

## count the number of Sox9 ChIP-seq reads in the promoter regions of DEG and Ctrl
 
open(INA,"Random_1000_control_genes.txt")||die("Can't open INA:$!\n");
open(INB,"DEG_2022_N2a_siRNA_ExonicGene_overlapped.xls")||die("Can't open INB:$!\n");

open(INCA,"/Users/jerry/Analysis/Genome/Ensembl_100/Mus_musculus.GRCm38.100.gtf_plus_final.exon")||die("Can't open INA:$!\n");
open(INCB,"/Users/jerry/Analysis/Genome/Ensembl_100/Mus_musculus.GRCm38.100.gtf_minus_final.exon")||die("Can't open INA:$!\n");
 
open(IND,"Sox9/GSE69109_Nasal_Chondrocyte_Sox9_ChIPseq_rep1.sam")||die("Can't open IND:$!\n");
open(OUT,">Sox9/Sox9_ChIPseq_DEG_Ctrl_promoter_count.xls")||die("Can't write OUT:$!\n");


while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)$/){chomp; $a1++; $ctrl{$1}=1; $total{$1}=1;}
 else{print "Error1\t$_\n";}
}

while(<INB>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t/){chomp; $a2++; $deg{$1}=1; $total{$1}=1;}
 else{print "Error2\t$_\n";}
}


while(<INCA>)
{
 chomp;
 if(/^chr(\w\w?)\:(\d+)\-(\d+)\:(ENSMUSG\d+\_[\w\.\-]+)\_(exon\d+)\t(\+)$/)
 {
  if($5 eq "exon1")
  {
   if(exists $total{$4})
   {
    $a3++;
    $gene_id="$4"; $count{$gene_id}=0;
    for($i=$2-5000;$i<=$2+5000-1; $i++)
    {
     $id="$1_$i";
     if(exists $promoter{$id}){$promoter{$id}.=";;$gene_id";} ## overlaped regions, more exon IDs
     else{$promoter{$id}=$gene_id;}
    } 
   }
  }
 }
 else{print "Error3\t$_\n";}
}

while(<INCB>)
{
 chomp;
 if(/^chr(\w\w?)\:(\d+)\-(\d+)\:(ENSMUSG\d+\_[\w\.\-]+)\_(exon\d+)\t(\-)$/)
 {
  if($5 eq "exon1")
  {
   if(exists $total{$4})
   {
    $a3++;
    $gene_id="$4"; $count{$gene_id}=0;
    for($i=$3+5000;$i>=$3-5000+1; $i--)
    {
     $id="$1_$i";
     if(exists $promoter{$id}){$promoter{$id}.=";;$gene_id";} ## overlaped regions, more exon IDs
     else{$promoter{$id}=$gene_id;}
    } 
   }
  }
 }
 else{print "Error3\t$_\n";}
}


while(<IND>)
{
 chomp;
 if(/^([\w\.\:\-]+)\t(\d+)\t(\w\w?)\t(\d+)\t\d+\t42M\t/)
 {
  $read_id=$1;
  $start=$4;             ## read mapping start

  $total_reads++; ## total read
  print "Processes lines: $total_reads\n" if($total_reads%1000000==0);

  $label=0; 
  for ($j=$start; $j<=($start+42-1); $j++)
  {
   $id2="$3_$j";
   if(exists $promoter{$id2}) ## read overlap with promoter 
   {
    $label=1;
    if(exists $name{$read_id}) ## this read already overlap with promoter
    {
     if($name{$read_id} =~ /$promoter{$id2}/){} ## already this gene ID
     else{$name{$read_id}.=";;$promoter{$id2}";} ## add this gene ID to this reads
    }
    else{$name{$read_id}=$promoter{$id2};} ##
   }
  }

  if($label==0){$non_overlap++;}
  elsif($label==1) ## pair mapped to exon
  {
   $overlap++;
 
   @arraylist=split(/;;/,$name{$read_id});
   foreach (@arraylist){$tmphash{$_}=0;}
   @newlist=keys %tmphash;
     
   foreach (@newlist){$count{$_}++;};
  }
  else{$others++;}
  
  delete $name{$read_id}; ## delete information of this reads from HASH
  foreach (keys %tmphash){delete $tmphash{$_};}
 }
 else{print "error4\t$_\n";}
}

print OUT "\tCategory\tCount\n";
foreach (keys %total)
{
 print OUT "$_\t";
 if(exists $ctrl{$_}){$b1++; print OUT "Ctrl\t$count{$_}\n";}
 if(exists $deg{$_}){$b2++; print OUT "DEG\t$count{$_}\n";}
 $b3++;
}

print "Ctrl: $a1\tDEGs: $a2\tTotal: $a3\n";
print "Ctrl: $b1\tDEGs: $b2\tTotal: $b3\n";

print "Total-reads: $total_reads\noverlap: $overlap\n";
print "Non-overlap: $non_overlap\nOthers: $others\n";

close INA; close INB; close INCA; close INCB; close IND;
close OUT;
