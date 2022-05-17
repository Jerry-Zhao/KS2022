#! /usr/local/perl -w
## generate 1000 random genes
 
# rand(6) will generate a floating point number between 0 and 6 (6 excluded).
# int rand(6) will return the integer part of it which can be 0, 1, 2, 3, 4, 5 (but cannot be 6).
# 1 + int rand(6) will return one more. One of the following numbers: 1, 2, 3, 4, 5, 6

open(INA,"edgeR_glmQLF_2022_N2a_siRNA_siHs6st1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(INB,"edgeR_glmQLF_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");
open(INC,"Merged_2022_N2a_siRNA_totalRNA_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");

open(OUT,">Random_1000_control_genes.txt")||die("Can't write OUT:$!\n");

while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  if($2 < 0.05){$a1++; $deg{$1}=1;}
 }
 else{print "Error1\t$_\n";}
}


while(<INB>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  if($2 < 0.05){$a2++; $deg{$1}=1;}
 }
 else{print "Error2\t$_\n";}
}

while(<INC>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t\d+\t/)
 {
  if(exists $deg{$1}){$a3++;}
  else{push (@genelist, $1);}
 }
 else{print "Error3\t$_\n";}
}

$geneno=@genelist;
for($i=0;$i<1000;$i++)
{
 $number= int rand($geneno); ## random from the array
 print OUT "$genelist[$number]\n";
}

print "siHs6st1-DEG: $a1\tsiFgfr1-DEG: $a2\tTotal-DEG: $a3\n";

close INA; close INB; close INC;
close OUT;



