library(tesseract)
library(magick)
args = commandArgs(trailingOnly=TRUE)

input <- image_read(args[1])

text <- input %>%
  image_modulate(brightness = 150) %>%
  image_trim(fuzz = 40) %>%
  image_write(format = 'png', density = '300x300') %>%
  tesseract::ocr() 

text.mod <- gsub("\n"," ",text)
text.mod <- strsplit(text.mod," ")[[1]]
num.index <- seq(1,length(text.mod),2)
pwd.index <- seq(2,length(text.mod),2)
nums <- text.mod[num.index]
nums <- gsub(":","",nums)
pwds <- text.mod[pwd.index]
otp.table <- data.frame(nums=as.numeric(nums),pwds=pwds)
otp.table <- otp.table[order(otp.table$nums),]
write.table(otp.table,"otp_table.txt",sep="\t",row.names=F,col.names=F,quote=F)