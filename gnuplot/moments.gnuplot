#
# Macros for plotting output of moments-per-line.awk
#
# Expects output with first column for x-axis as follows:
# skipped n median low_quartile hi_quartile mean avg_dev std_dev vari skew
#
set macros

# median
moments_median = "u 1:3"

# interquartile range as filled curve
moments_IQR = "u 1:4:5 w filledcurve fs transparent solid 0.25"

# interquartile range as errorbars
moments_IQR_BARS = "u 1:3:4:5 w yerrorbars"


# mean
moments_mean = "u 1:6"

# 95% confidence around mean as filled curve
moments_CI = "u 1:($6-(1.96*$8/sqrt($2))):($6+(1.96*$8/sqrt($2))) w filledcurve fs transparent solid 0.25"