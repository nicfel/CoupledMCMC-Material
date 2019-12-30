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
library(data.table)
library(stats)


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
method = c("MCMC", "target=0.468", "target=0.234", "target=0.117")

first = TRUE
# Read In all data ---------------------------------
for (i in seq(1,length(temperatures),1)){
  
  print(i)
  log <- list.files(path="./out_ess_estimates/", pattern=paste(temperatures[[i]], ".", "*[0123456789].log",sep=""), full.names = TRUE)
  for (j in seq(1,length(log))){
    # for (j in seq(1,100)){
    # Read in the SISCO *.logs
    # t <- read.table(log[j], header=TRUE)
    t <- fread(log[j], header=TRUE,select = 2)
    
    if (length(t$posterior)!=10001 && length(t$posterior)!=40001){
      file.remove(log[[j]])
      file.remove(gsub("./out_ess_estimates/","./ess/",log[[j]]))
    }else{
      
    
      new.val <- t[-seq(1,ceiling(length(t$posterior)/10)), ]
      new.val = new.val[seq(1,length(new.val$posterior),10),]
      
      if (first){
        val = new.val
        first = F
      }else{
        val = rbind(val, new.val)
      }
    }
    
  }
}



first = TRUE
# Read In Data ---------------------------------
for (i in seq(1,length(temperatures),1)){

  print(i)
  log <- list.files(path="./out_ess_estimates/", pattern=paste(temperatures[[i]], ".", "*[0123456789].log",sep=""), full.names = TRUE)
  for (j in seq(1,length(log))){
  # for (j in seq(1,100)){
    # Read in the SISCO *.logs
    # t <- read.table(log[j], header=TRUE)
    t <- fread(log[j], header=TRUE,select = 2)
    

    if (i==1){
      t = t[seq(1,length(t$posterior),4)]
    }
    
    t <- t[-seq(1,ceiling(length(t$posterior)/10)), ]
    

    post_ess = effectiveSize(t)
    if (post_ess[[1]]<100){
      print(log[j])
    }else{
      new.dfname <- data.frame(method=method[[i]],posterior_dist = ks.test(val$posterior,t$posterior)[[1]])
      if (first){
        dfname = new.dfname
        first = F
      }else{
        dfname = rbind(dfname, new.dfname)
      }
    }
  }

}



p_speed <- ggplot(dfname)+
  geom_violin(aes(x=method, y=posterior_dist),colour="black") +
  theme(legend.position="none")  +
  ylab("KS distance") + 
  scale_y_continuous(limits=c(0,0.1)) +
  xlab("") + 
  theme_minimal()

plot(p_speed)

ggsave(plot=p_speed, paste("../../Figures/ksdist_coda.pdf", sep=""),width=6, height=3)
