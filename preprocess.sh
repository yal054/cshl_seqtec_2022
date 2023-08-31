#!/bin/bash

#------------------#
# QC at bulk level #

# correlation between replicates
for i in sample_1 sample_2
do echo $i;
bamCoverage -b 00.data/${i}.srt.bam -o 00.data/${i}.coverage.bw
done;

multiBigwigSummary bins -b 00.data/*.coverage.bw -o 00.data/multiBigwigSummary.results.npz

plotCorrelation \
-in 00.data/multiBigwigSummary.results.npz \
--corMethod spearman --skipZeros \
--plotTitle "Spearman Correlation of Average Scores Per Genomic Bins" \
--whatToPlot scatterplot \
--removeOutliers \
--xRange 0 8 --yRange 0 8 --log1p \
-o 00.data/scatterplot_SpearmanCorr_bigwigScores.pdf  \
--outFileCorMatrix 00.data/SpearmanCorr_bigwigScores.tab

# fragment size distribution

for i in sample_1 sample_2
do echo $i;
Rscript bin/ATACseqQC.fragSizeDist.R -i 00.data/${i}.srt.bam -o 00.data/${i}
done;
