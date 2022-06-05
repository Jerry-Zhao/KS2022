#! /usr/local/perl -w
# compare three edgeR results

open(INA,"edgeR_glmQLF_2022_N2a_siRNA_siHs6st1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(INB,"edgeR_glmQLF_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");
open(INC,"edgeR_glmQLF_Cerebellum_P4_Chd7_Ctrl_KO_exonic_gene_Jerry.xls")||die("Can't open INB:$!\n");
open(OUT,">DEGs_overlap_compare_Hs6st1_Fgfr1_Chd7.xls")||die("Can't write OUT:$!\n");
open(OUB,">DEGs_1052_overlap_compare_Hs6st1_Fgfr1_Chd7.xls")||die("Can't write OUT:$!\n");
 
while(<INA>)
{
 chomp;
 if(/^[\w\:\-]*(ENSMUSG\d+\_[\w\.\-]+)[\:\w\+\-]*\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  $hs6st12{$1}="$2\t$3";
  if($3 < 0.05) {$a1++; $hs6st1{$1}=1;}
 }
 else{print "Error1\t$_\n";}
}

while(<INB>)
{
 chomp;
 if(/^[\w\:\-]*(ENSMUSG\d+\_[\w\.\-]+)[\:\w\+\-]*\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  $fgfr12{$1}="$2\t$3";
  if($3 < 0.05) {$a2++; $fgfr1{$1}=1;}
 }
 else{print "Error2\t$_\n";}
}
 
print OUB "\tHs6st1-FC\tHs6st1-FDR\tFgfr1-FC\tFgfr1-FDR\tChd7-FC\tChd7-FDR\n";
while(<INC>)
{
 chomp;
 if(/^[\w\:\-]*(ENSMUSG\d+\_[\w\.\-]+)[\:\w\+\-]*\t([\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  $chd72{$1}="$2\t$3";
  if($3 < 0.05) {$a3++; $chd7{$1}=1;}
  if((exists $hs6st1{$1}) and (exists $fgfr1{$1}))
  {$e1++; print OUB "$1\t$hs6st12{$1}\t$fgfr12{$1}\t$2\t$3\n"}
 }
 else{print "Error3\t$_\n";}
}

print "Hs6st1-total: $a1\tFgfr1-total: $a2\tChd7-total: $a3\n";


print OUT "\tHs6st1-FC\tHs6st1-FDR\tFgfr1-FC\tFgfr1-FDR\tChd7-FC\tChd7-FDR\n";
foreach (keys %hs6st1)
{
 $b1++; 
 if(exists $fgfr1{$_}){if(exists $chd7{$_}){$b3++; print OUT "$_\t$hs6st12{$_}\t$fgfr12{$_}\t$chd72{$_}\n";} else{$b2++;}}
 elsif(exists $chd7{$_}){$b4++;}
 else{$b5++;}
}
print "Hs6st1-total: $b1\tHs6st1-Fgfr1-Chd7: $b3  \tHs6st1-Fgfr1: $b2\tHs6st1-Chd7: $b4\tHs6st1-specific: $b5\n";




foreach (keys %fgfr1)
{
 $c1++;
 if(exists $hs6st1{$_}){if(exists $chd7{$_}){$c3++;} else{$c2++;}}
 elsif(exists $chd7{$_}){$c4++;}
 else{$c5++;}
}
print "Fgfr1-total: $c1\tFgfr1-Hs6st1-Chd7: $c3  \tFgfr1-Hs6st1: $c2\tFgfr1-Chd7: $c4\tFgfr1-specific: $c5\n";




foreach (keys %chd7)
{
 $d1++;
 if(exists $hs6st1{$_}){if(exists $fgfr1{$_}){$d3++;} else{$d2++;}}
 elsif(exists $fgfr1{$_}){$d4++;}
 else{$d5++;}
}
print "Chd7-total: $d1\tChd7-Hs6st1-Fgfr1: $d3  \tChd7-Hs6st1: $d2\tChd7-Fgfr1: $d4\tChd7-specific: $d5\n";


print "1052 overlapping DEGs: $e1\n";

close INA; close INB;
