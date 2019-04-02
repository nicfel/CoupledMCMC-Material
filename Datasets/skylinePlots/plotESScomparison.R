######################################################
######################################################
# Here the inferred mean coalescent and migration
# rate ratios are plotted
######################################################
######################################################
library(ggplot2)
# needed to calculate ESS values
library(coda)
library("methods")


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

temperatures = c("hcv_coal_mcmc", "hcv_coal_coupled_cold", "hcv_coal_coupled_warm", "hcv_coal_coupled_hot")
method = c("mcmc", "cold", "warm", "hot")

first = TRUE
# Read In Data ---------------------------------
for (i in seq(1,length(temperatures),1)){
  print(i)
  log <- list.files(path="./ess/", pattern=paste(temperatures[[i]], ".", "*[0123456789].log",sep=""), full.names = TRUE)
  for (j in seq(1,length(log))){
    # Read in the SISCO *.logs
    t <- read.table(log[j], header=TRUE)
    
    post_ess = t[1,"ESS"]
    
    new.dfname <- data.frame(method=method[[i]],posterior_ess = post_ess)
    if (first){
      dfname = new.dfname
      first = F
    }else{
      dfname = rbind(dfname, new.dfname)
    }
  }
}



p_speed <- ggplot(dfname)+
  geom_violin(aes(x=method, y=posterior_ess),colour="black") +
  theme(legend.position="none")  +
  ylab("ESS") + 
  theme_minimal()

plot(p_speed)

ggsave(plot=p_speed, paste("../../Figures/ess.pdf", sep=""),width=6, height=3)
