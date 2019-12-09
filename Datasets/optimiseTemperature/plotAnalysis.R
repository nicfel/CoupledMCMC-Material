######################################################
######################################################
# Here the inferred mean coalescent and migration
# rate ratios are plotted
######################################################
######################################################
library(ggplot2)
library(coda)
library("colorblindr")

# clear workspace
rm(list = ls())

# Set the directory to the directory of the file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


out_files = list.files(path="./out_converted/", pattern = "*.out", full.names=T)


initial_deltat = c(0.0001, 0.0010, 0.0100, 0.1000);
target_values = c(0.117,0.234,0.468);
swap_values = c(100,1000);


for (i in seq(1,length(out_files))){
  t = read.table(out_files[[i]], header=TRUE, sep="\t")
  new.dat = data.frame(iteration=t[,"sample"], acceptance=t[,"swapProbability"], temperature=t[,"Temperature"])
  tmp = strsplit(out_files[[i]], split="_")
  new.dat$initial = paste(initial_deltat[as.numeric(tmp[[1]][3])])
  new.dat$target = paste(target_values[as.numeric(tmp[[1]][4])])
  new.dat$swap = paste("swap frequency =", as.character(swap_values[as.numeric(gsub(".out","",tmp[[1]][5]))]))
  new.dat$number = i

  if (i==1){
    dat = new.dat
  }else{
    dat = rbind(dat, new.dat)
  }
}


library(RColorBrewer)
my_orange = brewer.pal(n = 5, "Oranges")[2:5]

p.post <- ggplot(na.omit(dat))+
  geom_line(aes(x=iteration,y=acceptance, color=target, group=number),size=1)+
  scale_y_continuous(breaks=c(0.1,0.3,0.5,0.7)) +
  theme_minimal() +
  scale_x_continuous(breaks=c(0,5*10^6,10^7,1.5*10^7,2*10^7), labels=c("0","5e6","1e7","1.5e7","2e7")) +
  ylab("average acceptance probability") +
  scale_color_manual(name="target\nacceptance\nprobability", values = rev(my_orange))+
  facet_wrap(.~swap, ncol=2)
plot(p.post)
ggsave(plot=p.post,paste("../../Figures/skyline_acceptance.pdf", sep=""),width=9, height=3)

p.post <- ggplot(na.omit(dat))+
  geom_line(aes(x=iteration,y=temperature, color=target, group=number),size=1)+
  scale_y_log10(limits=c(0.001,1))+
  scale_x_continuous(breaks=c(0,5*10^6,10^7,1.5*10^7,2*10^7), labels=c("0","5e6","1e7","1.5e7","2e7")) +
  theme_minimal() +
  ylab(expression(Delta*t)) +
  scale_color_manual(name="target\nacceptance\nprobability", values = rev(my_orange))+
  facet_wrap(.~swap, ncol=2)
# theme(legend.position = "none")
plot(p.post)
ggsave(plot=p.post,paste("../../Figures/skyline_temperature.pdf", sep=""),width=9, height=3)
