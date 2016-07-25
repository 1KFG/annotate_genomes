
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "AED.pdf"
}
input.file = args[1]
aed <- read.table(input.file,header=T)
pdf(args[2])
breaks = seq(0, 1, by=0.25)
duration.cut  = cut(aed$AED,breaks,right=FALSE)
duration.freq = table(duration.cut)
cumlfreq0 = c(0, cumsum(duration.freq))
plot(breaks, cumlfreq0,
main = "AED cumulative",
xlab="AED score",
ylab="Cumulative number of genes with AED score")

lines(breaks,cumlfreq0)
