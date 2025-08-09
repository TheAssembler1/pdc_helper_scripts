set terminal pngcairo size 900,600 enhanced font 'Verdana,10'
set output 'timing_bars.png'

set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9

set xtics rotate by -45 scale 0
set grid ytics

set ylabel "Time (seconds)"
set yrange [0:*]

set key outside top center horizontal

plot for [COL=2:5] 'gnuplot_data.dat' using COL:xtic(1) title columnheader

