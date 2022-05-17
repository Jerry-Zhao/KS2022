#! /usr/local/perl -w
# Hs6st1-DEG: 1436	Fgfr1-DEG: 4804
# Overlap-DEG: 1052	Hs6st1-specific-DEG: 384	Fgfr1-specific-DEG: 3752

open(INA,"edgeR_glmQLF_2022_N2a_siRNA_siHs6st1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(INB,"edgeR_glmQLF_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");

open(OUA,">DEG_2022_N2a_siRNA_ExonicGene_overlapped.xls")||die("Can't write OUA: $!\n");
open(OUB,">DEG_2022_N2a_siRNA_ExonicGene_siHs6st1_specific.xls")||die("Can't write OUA: $!\n");
open(OUC,">DEG_2022_N2a_siRNA_ExonicGene_siFgfr1_specific.xls")||die("Can't write OUA: $!\n");
 
while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  $hs6st1{$1}="$2\t$3";
  if($3<0.05){$total{$1}=1; $hs6st1deg{$1}=1; $a1++; }
 }
 else{print "error1\t$_\n";}
}

while(<INB>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  $fgfr1{$1}="$2\t$3";
  if($3<0.05){$total{$1}=1; $fgfr1deg{$1}=1; $b1++;}
 }
 else{print "error2\t$_\n";}
}

print OUA "ID\tHs6st1_FC\tHs6st1_FDR\tFgfr1_FC\tFgfr1_FDR\n";
print OUB "ID\tHs6st1_FC\tHs6st1_FDR\tFgfr1_FC\tFgfr1_FDR\n";
print OUC "ID\tHs6st1_FC\tHs6st1_FDR\tFgfr1_FC\tFgfr1_FDR\n";

foreach (keys %total)
{
 if(exists $hs6st1deg{$_}) 
 {
  if(exists $fgfr1deg{$_}) {$c1++; print OUA "$_\t$hs6st1{$_}\t$fgfr1{$_}\n";}
  else ## Hs6st1-specific
  {
   if(exists $fgfr1{$_}) {$c2++; print OUB "$_\t$hs6st1{$_}\t$fgfr1{$_}\n";}
   else {$c2++; print OUB "$_\t$hs6st1{$_}\t-\t-\n";}
  }
 }
 
 if(exists $fgfr1deg{$_})
 {
  if(!exists $hs6st1deg{$_}) ## Fgfr1-specific 
  {
   if(exists $hs6st1{$_}) {$c3++; print OUC "$_\t$hs6st1{$_}\t$fgfr1{$_}\n";}
   else{$c3++; print OUC "$_\t-\t-\t$fgfr1{$_}\n";}
  }
 }
}

print "Hs6st1-DEG: $a1\tFgfr1-DEG: $b1\n";
print "Overlap-DEG: $c1\tHs6st1-specific-DEG: $c2\tFgfr1-specific-DEG: $c3\n";

close INA; close INB;
close OUA; close OUB; close OUC;

