set datafile separator ','
set terminal svg size 900,550 dynamic enhanced font 'sans,11'
set output 'generated/throughput-gnuplot.svg'
set key left top
set xlabel 'Worker processes'
set ylabel 'Median throughput (requests/s)'
set grid ytics
set xrange [0.5:4.5]
plot 'generated/summary.csv' using (strcol(1) eq 'baseline' ? $2 : 1/0):5 \
       with linespoints lw 2 pt 7 title 'Baseline', \
     '' using (strcol(1) eq 'candidate' ? $2 : 1/0):5 \
       with linespoints lw 2 dt 2 pt 5 title 'Candidate'
