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


logs <- list.files(path="./out", pattern="*.rep1.log", full.names = TRUE)
names = c("target probability = 0.117", "target probability = 0.234", "target probability = 0.468", "MCMC")

# compute true values using all runs at max heating 
t.true = list()
for (j in seq(1,5)){
  log = gsub("rep1",paste("rep", j,sep=""), logs[[1]] )
  t.new = read.table(log, header=TRUE, sep="\t")
  t.new = t.new[-seq(1,length(t.new$Sample)/10),]
  t.true[[j]] = t.new
}

by = 100
first = T
for (i in seq(1,length(logs))){
  print(i)
  for (j in seq(1,5)){
    log = gsub("rep1",paste("rep", j,sep=""), logs[[i]] )
    t = read.table(log, header=TRUE, sep="\t")
    t = t[-seq(1,length(t$Sample)/10),]
    dist = c()
    # build "true" post list
    true.post = c()
    for (k in seq(1,5)){
      if (k!=j){
        true.post <- append(true.post, t.true[[k]]$posterior)
      }
    }
    
    for (k in seq(by,length(t$posterior),by)){
      dist <- append(dist, ks.test(true.post,t$posterior[1:k])$statistic)
    }
    new.data = data.frame(ks.dist = dist, iteration=t[seq(by,length(t$posterior),by), "Sample"], replicate=paste(j), method = names[[i]])
    if (first){
      dat = new.data
      first = F
    }else{
      dat = rbind(dat,new.data)
    }
    
  }
}

# use the matlab standard colors to plot
col0 <- rgb(red=0.0, green=0.4470,blue=0.7410)
col1 <- rgb(red=0.8500, green=0.3250,blue=0.0980)
col2 <- rgb(red=0.9290, green=0.6940,blue=0.1250)
col4 <- rgb(red=0.4660, green=0.6740,blue=0.1880)
col3 <- rgb(red=0.3010, green=0.7450,blue=0.9330)

p.post <- ggplot(data = transform(dat,
                                  method=factor(method,levels=c("MCMC", "target probability = 0.468", "target probability = 0.234", "target probability = 0.117")))) +
  geom_line(aes(x=iteration,y=ks.dist, color=replicate, group=replicate),size=1)+
  theme_minimal() +
  scale_y_log10() +
  ylab("KS distance between posterior probability distributions") +
  scale_colour_manual(name="replicate run", values=c("1" = col3,"2" = col0, "3" = col1, "4"=col2, "5"=col4)) +
  facet_wrap(.~method,ncol=2)
plot(p.post)
ggsave(plot=p.post,paste("../../Figures/ds1_ksdist.pdf", sep=""),width=9, height=9)

