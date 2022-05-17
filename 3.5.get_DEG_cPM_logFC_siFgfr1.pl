#! /usr/local/perl -w

open(INA,"edgeR_glmQLF_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(INB,"CPM_edgeR_2022_N2a_siRNA_siFgfr1_exonic_gene_Jerry.xls")||die("Can't open INA:$!\n");
open(OUT,">DEG_CPM_logFC_for_heatmap_siFgfr1.xls")||die("Can't write OUT:$!\n");

while(<INA>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t[\w\.\-]+\t([\w\.\-]+)$/)
 {
  if($2 < 0.05) {$deg{$1}=1; $a1++;}
 }
 else{print "error1\t$_\n";}
}

print OUT "\tCtrl1\tCtrl2\tCtrl3\tsiFgfr1_1\tsiFgfr1_2\tsiFgfr1_3\tsiFgfr1_4\n";
while(<INB>)
{
 chomp;
 if(/^(ENSMUSG\d+\_[\w\.\-]+)\t([\d\.]+)\t([\d\.]+)\t([\d\.]+)\t([\d\.]+)\t([\d\.]+)\t([\d\.]+)\t([\d\.]+)$/)
 {
  if(exists $deg{$1})
  {
   $b1++;
   $meancpm=($2+$3+$4)/3; 

   $ctrl1=log($2/$meancpm)/log(2);
   $ctrl2=log($3/$meancpm)/log(2);
   $ctrl3=log($4/$meancpm)/log(2);
   $kd1=log($5/$meancpm)/log(2);
   $kd2=log($6/$meancpm)/log(2);
   $kd3=log($7/$meancpm)/log(2);
   $kd4=log($8/$meancpm)/log(2);

   print OUT "$1\t$ctrl1\t$ctrl2\t$ctrl3\t$kd1\t$kd2\t$kd3\t$kd4\n";
  }
 }
 else{print "error2\t$_\n";}
}

print "DEG: $a1\t$b1\n";

close INA; close INB;
close OUT;




