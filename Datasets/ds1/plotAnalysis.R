######################################################
######################################################
# Analyses inferred topology and node heights of
# species trees
######################################################
######################################################
library(ggplot2)
library(ggtree)

# clear workspace
rm(list = ls())

# Set the directory to the directory of the file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


# combine all tree files
trees <- list.files(path="./out", pattern="*.rep1.trees", full.names = TRUE)


# define the names
names = c("target probability = 0.117", "target probability = 0.234", "target probability = 0.468", "MCMC")

# compare the clade probabilities between the first and the other runs, requires https://github.com/rbouckaert/Babel
first = TRUE
for (i in seq(1, length(trees))){
  for (j in seq(2,5)){
    tree1 = trees[[i]]
    tree2 = gsub("rep1",paste("rep", j,sep=""), trees[[i]] )
    # get the clade probabilities
    system("rm clades.txt")
    system(paste("/Applications/BEAST\\ 2.6.0/bin/applauncher CladeSetComparator -tree1", tree1, "-tree2", tree2, "-out clades.txt"))
    # read in the clade probabilities
    clades=read.table("clades.txt", header=F, sep=" ")
    new.cladeprob = data.frame(prob1=clades$V2,prob2=clades$V3)
    new.cladeprob$replicate = paste(j)
    new.cladeprob$method = names[[i]]
    
    if (first){
      cladeprob = new.cladeprob
      first=FALSE
    }else{
      cladeprob = rbind(cladeprob,new.cladeprob)
    }
  }
}
system("rm clades.txt")


# use the matlab standard colors to plot
col0 <- rgb(red=0.0, green=0.4470,blue=0.7410)
col1 <- rgb(red=0.8500, green=0.3250,blue=0.0980)
col2 <- rgb(red=0.9290, green=0.6940,blue=0.1250)
col4 <- rgb(red=0.4660, green=0.6740,blue=0.1880)
col3 <- rgb(red=0.3010, green=0.7450,blue=0.9330)


p_clade = ggplot(data = transform(cladeprob,
                                  method=factor(method,levels=c("MCMC", "target probability = 0.468", "target probability = 0.234", "target probability = 0.117")))) +
  geom_point(aes(x=prob1, y=prob2, color=replicate)) +
  facet_wrap(.~method,ncol=2) +
  ylab("clade probabilities in first run") + 
  xlab("clade probabilities in replicate run") +
  theme_minimal() +
  theme(panel.spacing = unit(1, "lines")) +
  scale_colour_manual(name="replicate run", values=c("2" = col0, "3" = col1, "4"=col2, "5"=col4))
plot(p_clade)

ggsave(plot=p_clade,paste("../../Figures/Clade_probabilities.pdf", sep=""),width=6, height=5)



