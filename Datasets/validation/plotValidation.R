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

# read in the mcmc and coupled mcmc runs
t.mcmc <- read.table("./out/structuredCoalescent-mcmc.log", header=TRUE, sep="\t")
t.coupled <- read.table("./out/structuredCoalescent-coupled.log", header=TRUE, sep="\t")

p.post <- ggplot()+
  geom_density(data=t.mcmc, aes(x=posterior,y=..density..), color="red")+
  geom_density(data=t.coupled, aes(x=posterior,y=..density..), linetype="dashed", color="blue")+
  theme_classic() 

p.height <- ggplot()+
  geom_density(data=t.mcmc, aes(x=tree.height,y=..density.., color="MCMC"),linetype="dotted", size=1)+
  geom_density(data=t.coupled, aes(x=TreeHeightLogger,y=..density.., color="Coupled MCMC"),linetype="dotted", size=0.5)+
  geom_density(data=t.mcmc, aes(x=tree.length,y=..density.., color="MCMC"), linetype="dashed", size=1)+
  geom_density(data=t.coupled, aes(x=TreeLengthLogger,y=..density.., color="Coupled MCMC"), linetype="dashed", size=0.5)+
  xlab("statistic") +
  annotate("text", x = 5, y = 0.25, label = "Tree Height") +
  annotate("text", x = 22, y = 0.05, label = "Tree Length") +
  scale_colour_manual(name="Sampling Method", values=c("red","blue"))
  theme(legend.position = "top")


plot(p.post)
plot(p.height)

ggsave(plot=p.height,paste("../../Figures/treeHeight.pdf", sep=""),width=6, height=5)
# ggsave(plot=p.rea,paste("../Figures/rho.png", sep=""),width=6, height=5)
