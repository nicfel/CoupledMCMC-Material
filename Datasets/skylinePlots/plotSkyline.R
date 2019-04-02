######################################################
######################################################
# Here the inferred mean coalescent and migration
# rate ratios are plotted
######################################################
######################################################
library(ggplot2)
library(coda)


# clear workspace
rm(list = ls())

# Set the directory to the directory of the file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

# use the matlab standard colors to plot
col0 <- rgb(red=0.0, green=0.4470,blue=0.7410)
col1 <- rgb(red=0.8500, green=0.3250,blue=0.0980)
col2 <- rgb(red=0.9290, green=0.6940,blue=0.1250)
col4 <- rgb(red=0.4660, green=0.6740,blue=0.1880)
col3 <- rgb(red=0.3010, green=0.7450,blue=0.9330)


# read in the mcmc and coupled mcmc runs
t.mcmc <- read.table("./out/hcv_coal_mcmc.log", header=TRUE, sep="\t")
t.coupled <- read.table("./out/hcv_coal_coupled.log", header=TRUE, sep="\t")

t.mcmc <- t.mcmc[-seq(1,ceiling(length(t.mcmc$Sample)/1000)), ]
t.coupled <- t.coupled[-seq(1,ceiling(length(t.coupled$Sample)/1000)), ]

p.post <- ggplot()+
  stat_density(data=t.mcmc, aes(x=posterior,y=..density.., color="MCMC"),geom="line" , size=1)+
  stat_density(data=t.coupled, aes(x=posterior,y=..density.., color="Coupled MCMC"),geom="line", linetype="twodash", size=1)+
  scale_colour_manual(name="Sampling Method", values=c("MCMC" = col4, "Coupled MCMC"=col0)) +
  theme_minimal() 
  # theme(legend.position = "none")
plot(p.post)
ggsave(plot=p.post,paste("../../Figures/posterior_skyline.pdf", sep=""),width=6, height=3)

# p.height <- ggplot()+
#   stat_density(data=t.mcmc, aes(x=tree.height,y=..density.., color="MCMC"),geom="line",linetype="dotted", size=1)+
#   stat_density(data=t.coupled, aes(x=TreeHeightLogger,y=..density.., color="cold chain"),geom="line",linetype="dotted", size=0.5)+
#   stat_density(data=t.heated, aes(x=TreeHeightLogger,y=..density.., color="heated chain"),geom="line",linetype="dotted", size=0.5)+
#   stat_density(data=t.mcmc, aes(x=tree.length,y=..density.., color="MCMC"),geom="line", linetype="dashed", size=1)+
#   stat_density(data=t.coupled, aes(x=TreeLengthLogger,y=..density.., color="cold chain"),geom="line", linetype="dashed", size=0.5)+
#   stat_density(data=t.heated, aes(x=TreeLengthLogger,y=..density.., color="heated chain"),geom="line", linetype="dashed", size=0.5)+
#   xlab("statistic") +
#   annotate("text", x = 15, y = 0.25, label = "Tree Height") +
#   annotate("text", x = 35, y = 0.05, label = "Tree Length") +
#   scale_colour_manual(name="Sampling Method", values=c("MCMC" = col4, "cold chain"=col3, "heated chain"=col1)) +
#   theme_minimal() 
#   # theme(legend.position = "none")


# plot(p.height)
# 
# ggsave(plot=p.height,paste("../../Figures/treeHeight.pdf", sep=""),width=6, height=3)
# ggsave(plot=p.post,paste("../../Figures/posterior.pdf", sep=""),width=6, height=3)
