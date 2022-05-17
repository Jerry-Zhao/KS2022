#! /usr/local/perl -w

open(INA,"count/2022_N2a_siRNA_ctrl_totalRNA_Rep1_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INB,"count/2022_N2a_siRNA_ctrl_totalRNA_Rep2_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INC,"count/2022_N2a_siRNA_ctrl_totalRNA_Rep3_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
 
open(IND,"count/2022_N2a_siRNA_siHs6st1_totalRNA_Rep1_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INE,"count/2022_N2a_siRNA_siHs6st1_totalRNA_Rep2_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INF,"count/2022_N2a_siRNA_siHs6st1_totalRNA_Rep3_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");

open(ING,"count/2022_N2a_siRNA_siFgfr1_totalRNA_Rep1_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INH,"count/2022_N2a_siRNA_siFgfr1_totalRNA_Rep2_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INI,"count/2022_N2a_siRNA_siFgfr1_totalRNA_Rep3_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INJ,"count/2022_N2a_siRNA_siFgfr1_totalRNA_Rep4_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");

open(OUT,">Merged_2022_N2a_siRNA_totalRNA_exonic_gene_Jerry.xls")||die("Can't write OUT:$!\n");

while(<INA>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$ctrl1{$1}=$2;}else{print"error1\t$_\n";}}
while(<INB>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$ctrl2{$1}=$2;}else{print"error2\t$_\n";}}
while(<INC>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$ctrl3{$1}=$2;}else{print"error3\t$_\n";}}

while(<IND>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$hs6st1{$1}=$2;}else{print"error4\t$_\n";}}
while(<INE>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$hs6st2{$1}=$2;}else{print"error5\t$_\n";}}
while(<INF>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$hs6st3{$1}=$2;}else{print"error6\t$_\n";}}

while(<ING>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$fgfr1{$1}=$2;}else{print"error7\t$_\n";}}
while(<INH>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$fgfr2{$1}=$2;}else{print"error8\t$_\n";}}
while(<INI>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$fgfr3{$1}=$2;}else{print"error9\t$_\n";}}
while(<INJ>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$fgfr4{$1}=$2;}else{print"error10\t$_\n";}}

print OUT "\tCtrl_rep1\tCtrl_rep2\tCtrl_rep3\t";
print OUT "siHs6st1_rep1\tsiHs6st1_rep2\tsiHs6st1_rep3\t";
print OUT "siFgfr1_rep1\tsiFgfr1_rep2\tsiFgfr1_rep3\tsiFgfr1_rep4\n";

my $a1=0;
foreach (keys %ctrl1)
{
 $a1++;
 print OUT "$_\t";
 print OUT "$ctrl1{$_}\t$ctrl2{$_}\t$ctrl3{$_}\t";
 print OUT "$hs6st1{$_}\t$hs6st2{$_}\t$hs6st3{$_}\t";
 print OUT "$fgfr1{$_}\t$fgfr2{$_}\t$fgfr3{$_}\t$fgfr4{$_}\n";
}

print "total-genes: $a1\n";

close OUT;


