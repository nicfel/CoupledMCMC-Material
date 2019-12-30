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
nr_its = 1000

# Read In all data ---------------------------------
for (i in seq(2,length(temperatures),1)){
  A = matrix(0,
             nrow=nr_its,
             ncol=100)
  B = matrix(0,
             nrow=nr_its,
             ncol=100)
  I = matrix(0,
             nrow=nr_its,
             ncol=1)
  
  print(i)
  log <- list.files(path="./out_ess_estimates/", pattern=paste(temperatures[[i]], ".", "*[0123456789].log",sep=""), full.names = TRUE)
  for (j in seq(1,length(log))){
    s <- fread(log[j], header=TRUE,select = 1)
    t <- fread(log[j], header=TRUE,select = 2)
    out <- fread(gsub("out_ess_estimates", "out_converted", gsub(".log", ".out",log[j])), header=TRUE,select = 4)
    if (length(t$posterior)!=10001 && length(t$posterior)!=40001){
      file.remove(log[[j]])
      file.remove(gsub("./out_ess_estimates/","./ess/",log[[j]]))
    }else{

      new.val = data.frame(method=method[[i]])
      c=1
      for (k in seq(ceiling(length(t$posterior)/100),length(t$posterior),ceiling(length(t$posterior)/nr_its))){
        A[c,j] = as.numeric(t[k,"posterior"])
        if (i>1){
          B[c,j] = as.numeric(out[k,"Temperature"])
        }
        if (j==1){
          I[c] = as.numeric(s[k,"Sample"])
        }
        c=c+1
      }
    }
  }
  for (j in seq(1,nr_its-99)){
    if (i>1){
      hpdint = HPDinterval(as.mcmc(A[j,]))
      hpdint.temp = HPDinterval(as.mcmc(B[j,]))
      new.val=data.frame(x=I[j],m=mean(A[j,]),sl=hpdint[1,"lower"], su=hpdint[1,"upper"],method=method[[i]],
                         tm=mean(B[j,]),tsl=hpdint.temp[1,"lower"],tsu=hpdint.temp[1,"upper"])
    }else{
      hpdint = HPDinterval(as.mcmc(A[j,]))
      new.val=data.frame(x=I[j],m=mean(A[j,]),sl=hpdint[1,"lower"], su=hpdint[1,"upper"],method=method[[i]],tm=NA,ts=NA)
    }
    if (first){
      val = new.val
      first = F
    }else{
      val = rbind(val, new.val)
    }
  }
}

p_sd <- ggplot(val)+
  geom_line(aes(x=x,y=m)) +
  geom_ribbon(aes(x=x,ymin=sl,ymax=su, alpha=0.1))+
  theme(legend.position="none")  +
  ylab("posterior probability values") + 
  xlab("iteration") + 
  facet_wrap(.~method,ncol=3)+
  scale_x_continuous(breaks=c(0,5*10^6,10^7), labels=c("0","5e6","1e7")) +
  theme_minimal()+
  theme(legend.position = "none")
plot(p_sd)

sub_val = na.omit(val)

p_temp <- ggplot(sub_val)+
  geom_line(aes(x=x,y=tm)) +
  geom_ribbon(aes(x=x,ymin=tsl,ymax=tsu, alpha=0.1))+
  theme(legend.position="none")  +
  ylab(expression(Delta*t)) +
  xlab("iteration") + 
  facet_wrap(.~method,ncol=3)+
  scale_x_continuous(breaks=c(0,5*10^6,10^7), labels=c("0","5e6","1e7")) +
  theme_minimal() +
  theme(legend.position = "none")
plot(p_temp)


ggsave(plot=p_sd, paste("../../Figures/post_values.pdf", sep=""),width=6, height=3)
ggsave(plot=p_temp, paste("../../Figures/temp_values.pdf", sep=""),width=6, height=3)
