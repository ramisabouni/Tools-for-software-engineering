set datafile separator ','
set terminal svg size 900,550 dynamic enhanced font 'sans,11'
set output 'generated/throughput-gnuplot.svg'
set xlabel 'Worker processes'
set ylabel 'Throughput (requests/s)'
set grid ytics
# TODO: read generated/summary.csv and plot deterministic baseline/candidate series
# with redundant line types and point types.
