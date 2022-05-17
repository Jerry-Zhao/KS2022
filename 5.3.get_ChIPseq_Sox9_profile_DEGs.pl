#! /usr/local/perl -w

open(INA,"DEG_2022_N2a_siRNA_ExonicGene_overlapped.xls")||die("Can't open INA:$!\n");
open(INBA,"/Users/jerry/Analysis/Genome/Ensembl_100/Mus_musculus.GRCm38.100.gtf_plus_final.exon")||die("Can't open INA:$!\n");
open(INBB,"/Users/jerry/Analysis/Genome/Ensembl_100/Mus_musculus.GRCm38.100.gtf_minus_final.exon")||die("Can't open INA:$!\n");
open(IND,"DEG_2022_N2a_siRNA_ExonicGene_overlapped.xls")||die("Can't open IND:$!\n");
 
print "Please enter the bg file name: no need the '.bg'\n";
chomp($name=<STDIN>);

open(INC,"Sox9/$name.bg")||die("Can't open INA:$!\n");
open(OUT,">Sox9/heatmap/Heatmap_$name.txt")||die("Can't open INA:$!\n");
 

print "Working on the file 1 of 4.\n";
while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t([\w\.\-]+)\t[\w\.\-]+\t([\w\.\-]+)\t[\w\.\-]+$/)
 {
  chomp;
  $a1++; $deg{$1}=1;
 }
 else{print "Error1\t$_\n";}
}

print "Working on the file 2 of 4.\n";
while(<INBA>)
{
 chomp;
 if(/^chr(\w\w?)\:(\d+)\-(\d+)\:(ENSMUSG\d+\_[\w\.\-]+)\_(exon\d+)\t(\+)$/)
 {
  if($5 eq "exon1")
  {
   if(exists $deg{$4})
   {
    $b23++; $chr{$4}=$1; $str{$4}=$6; $tss{$4}=$2;
    foreach ($i=$2-5000;$i<=$2+5000-1; $i++){$id="$1_$i"; $count{$id}=0;}
   } 
  }
 }
 else{print "error2\t$_\n";}
}

print "Working on the file 2 of 4.\n";
while(<INBB>)
{
 chomp;
 if(/^chr(\w\w?)\:(\d+)\-(\d+)\:(ENSMUSG\d+\_[\w\.\-]+)\_(exon\d+)\t(\-)$/)
 {
  if($5 eq "exon1")
  {
   if(exists $deg{$4})
   {
    $b23++; $chr{$4}=$1; $str{$4}=$6; $tss{$4}=$3;
    foreach ($i=$3+5000;$i>=$3-5000+1; $i--){$id="$1_$i"; $count{$id}=0;}
   }
  }
 }
 else{print "error2\t$_\n";}
}

print "Working on the file 3 of 4.\n";
while(<INC>)
{
 chomp;
 if(/^(\w\w?)\s+(\d+)\s+(\d+)\s+(\d+)$/)
 {
  for($j=$2; $j<$3; $j++)
  {
   $id2="$1_$j"; if(exists $count{$id2}){$count{$id2}=$4;}
  }
 }
 else{print "error3\t$_\n";}
}

print OUT "\tsiHs6st1FC\tsiFgfr1FC";
for($m=-5000;$m<5000;$m++){print OUT "\t$m";}
print OUT "\n";  

print "Working on the file 4 of 4.\n";
while(<IND>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t([\w\.\-]+)\t[\w\.\-]+\t([\w\.\-]+)\t[\w\.\-]+$/)
 {
  chomp;
  $c23++; 
  print OUT "$1\t$2\t$3";
  if(exists $str{$1})
  {
   if($str{$1} eq "+")
   {
    foreach ($i=$tss{$1}-5000;$i<=$tss{$1}+5000-1; $i++)
    {
     $id="$chr{$1}_$i"; 
     print OUT "\t$count{$id}";
    }
   }

   if($str{$1} eq "-")
   {
    foreach ($i=$tss{$1}+5000;$i>=$tss{$1}-5000+1; $i--)
    {
     $id="$chr{$1}_$i"; 
     print OUT "\t$count{$id}";
    }
   }
  }
  else{print "error not exists: $1\n";}
  
  print OUT "\n";
 }
 else{print "Error4\t$_\n";}
}

print "Overlap-DEG: $a1 $b23 $c23\n";

close INA; close INBA; close INBB; close INC; close IND;
close OUT;

