args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
samples <- list.files(path)
for(i in 1:length(samples)){
  to.read <- samples[i]
  full.path <- paste(path,to.read,"abundance.tsv",sep="/")
  abundance <- read.table(full.path,head=T,stringsAsFactors = F)
  assign(to.read,abundance)
}
target_id <- abundance$target_id
gene.symbols <- sapply(target_id, function(x) strsplit(x,split="\\|")[[1]][6])
unique.genes <- unique(gene.symbols)
unique.genes <- na.omit(unique.genes)
gene.expression.counts <- array(NA,dim=c(length(unique.genes),length(samples)))
rownames(gene.expression.counts) <- unique.genes
colnames(gene.expression.counts) <- samples
for(i in 1:length(samples)){
  to.aggregate <- samples[i]
  abundance <- get(to.aggregate)
  est.counts <- abundance$est_counts
  aggregate.counts <- aggregate(est.counts,by=list(gene.symbols),FUN="sum")
  gene.expression.counts[,i] <- aggregate.counts[,2]
}
gene.expression.counts <- cbind.data.frame(Genes=unique.genes,gene.expression.counts)
out.path <- paste(args[2],"geneExpressionCounts.txt",sep="/")
write.table(gene.expression.counts,out.path,sep="\t",quote=F,row.names=F)
