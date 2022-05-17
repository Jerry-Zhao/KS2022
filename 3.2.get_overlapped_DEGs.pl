#! /usr/local/perl -w

open(INA,"edgeR_glmQLF_2022_N2a_siRNA_siHs6st1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(INB,"edgeR_glmQLF_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");
open(OUT,">DEG_overlaped_1052.xls")||die("Can't write OUT:$!\n");
open(OUB,">DEG_Specific_Hs6st1_384_ID.txt")||die("Can't write OUB:$!\n");
open(OUC,">DEG_Specific_Fgfr1_3752_ID.txt")||die("Can't write OUC:$!\n");

while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+)\_[\w\.\-]+\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  if($3<0.05){$Hs6st1{$1}="$2\t$3"; $a1++;}
 }
 else{print "error1\t$_\n";}
}

print OUT "\tsiHs6st1_FC\tsiHs6st1_FDR\tsiFgfr1_FC\tsiFgfr1_FDR\n";
while(<INB>)
{
 chomp;
 if(/^(ENSMUSG\d+)(\_[\w\.\-]+)\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  if($4<0.05)
  {
   $a2++; $Fgfr1{$1}=1; 
   if(exists $Hs6st1{$1}) {$a3++; print OUT "$1$2\t$Hs6st1{$1}\t$3\t$4\n";}
   else{$b1++; print OUC "$1\n";}
  }
 }
 else{print "error2\t$_\n";}
}

foreach (keys %Hs6st1){if(!exists $Fgfr1{$_}){$b2++; print OUB "$_\n";}}

print "DEG-siHs6st1: $a1\tDEG-siFgfr1: $a2\tDEG-overlapped: $a3\n";
print "Hs6st1-specific-DEGs: $b2\tFgfr1-specific-DEGs: $b1\n";

close INA; close INB; close OUT;
close OUB; close OUC;
