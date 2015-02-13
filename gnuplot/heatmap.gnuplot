# Plotting a 256x256 heatmap from a matrix representation

# set terminal png transparent nocrop enhanced font arial 8 size 420,320
# set output 'pm3d.9.png'

set view map
set palette rgbformula 21,22,23
set cbrange [0:17]
set xrange [0:64]
set yrange [0:64]
unset xtics
unset ytics
set size square
unset colorbox
unset key

splot 'heatmap' matrix with image