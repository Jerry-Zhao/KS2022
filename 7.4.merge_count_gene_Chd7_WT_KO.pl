#! /usr/local/perl -w

open(INA,"count/GSE164360_Cerebellum_P4_Chd7_WT_rep1_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INB,"count/GSE164360_Cerebellum_P4_Chd7_WT_rep2_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INC,"count/GSE164360_Cerebellum_P4_Chd7_WT_rep3_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(IND,"count/GSE164360_Cerebellum_P4_Chd7_WT_rep4_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
open(INE,"count/GSE164360_Cerebellum_P4_Chd7_WT_rep5_exonic_gene_Jerry.txt")||die("Can't open INA:$!\n");
 
open(INF,"count/GSE164360_Cerebellum_P4_Chd7_KO_rep1_exonic_gene_Jerry.txt")||die("Can't open INF:$!\n");
open(ING,"count/GSE164360_Cerebellum_P4_Chd7_KO_rep2_exonic_gene_Jerry.txt")||die("Can't open INF:$!\n");
open(INH,"count/GSE164360_Cerebellum_P4_Chd7_KO_rep3_exonic_gene_Jerry.txt")||die("Can't open INF:$!\n");
open(INI,"count/GSE164360_Cerebellum_P4_Chd7_KO_rep4_exonic_gene_Jerry.txt")||die("Can't open INF:$!\n");
open(INJ,"count/GSE164360_Cerebellum_P4_Chd7_KO_rep5_exonic_gene_Jerry.txt")||die("Can't open INF:$!\n");
 
open(OUT,">Merged_GSE164360_Cerebellum_P4_Chd7_Ctrl_KO_exonic_gene_Jerry.xls")||die("Can't write OUT:$!\n");
 
while(<INA>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$Ctrl1{$1}=$2;}else{print"error1\t$_\n";}}
while(<INB>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$Ctrl2{$1}=$2;}else{print"error2\t$_\n";}}
while(<INC>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$Ctrl3{$1}=$2;}else{print"error3\t$_\n";}}
while(<IND>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$Ctrl4{$1}=$2;}else{print"error4\t$_\n";}}
while(<INE>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$Ctrl5{$1}=$2;}else{print"error5\t$_\n";}}

while(<INF>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$KO1{$1}=$2;}else{print"error6\t$_\n";}}
while(<ING>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$KO2{$1}=$2;}else{print"error7\t$_\n";}}
while(<INH>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$KO3{$1}=$2;}else{print"error8\t$_\n";}}
while(<INI>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$KO4{$1}=$2;}else{print"error9\t$_\n";}}
while(<INJ>){chomp;if(/^(ENSMUSG\d+\_[\w\.\-\(\)]+)\t(\d+)$/){$KO5{$1}=$2;}else{print"error10\t$_\n";}}

print OUT "\tCtrl_rep1\tCtrl_rep2\tCtrl_rep3\tCtrl_rep4\tCtrl_rep5\t";
print OUT "KO_rep1\tKO_rep2\tKO_rep3\tKO_rep4\tKO_rep5\n";

my $a1=0;
foreach (keys %Ctrl1)
{
 $a1++;
 print OUT "$_\t";
 print OUT "$Ctrl1{$_}\t$Ctrl2{$_}\t$Ctrl3{$_}\t$Ctrl4{$_}\t$Ctrl5{$_}\t";
 print OUT "$KO1{$_}\t$KO2{$_}\t$KO3{$_}\t$KO4{$_}\t$KO5{$_}\n";
}

print "total-genes: $a1\n";

close OUT;


