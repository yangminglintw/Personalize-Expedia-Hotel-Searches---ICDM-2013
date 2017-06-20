data <- read.csv("train.csv",na.strings='NULL')
d_ <- read.csv("xaa.csv",na.strings='NULL')

stock <- read.csv("045.csv",na.strings='NULL',encoding = "UTF-8", header = TRUE)

#data <- d[,-3:-51]
data$date_time <-substr(data[,2],0,10) 
data[is.na(data)] <- 0


library(dplyr)
group_by(data, date_time) %>% 
  summarise(comp8_rate_percent_diff = mean(comp8_rate_percent_diff)) -> tmp

write.csv(tmp, file="comp8_rate_percent_diff.csv", row.names = F, quote = F,fileEncoding = "big5")

s <- dir(path = ".")
x <- x[]
as.data.frame(x)
list_name[[]] <- 

for(i in 1:length(s)){
  paste("orca",i,sep="")
  assign(paste("orca",i,sep=""), list_name[[i]])
  x <- read.csv(s[i])
}

for(i in 1:length(s)){
  assign(paste('x', i, sep=''), as.numeric(read.csv(s[i])[,2]))
}

t <- c()
list()

stock_price <- as.numeric(stock[,2]) 

library(CausalImpact)
sum_usd <- read.csv("sum_usd.csv",header=T,na.strings=c('NA',''))
y <- as.numeric(sum_usd[,2])
d <- cbind(y, x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20
           ,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39
           ,x40,x41,x42)
matplot(d, type = "l")

time.points <- seq.Date(as.Date("2012-11-01"), by = 1, length.out = 242)
d <- zoo(cbind(y, x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20
                  ,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39
                  ,x40,x41,x42), time.points)
head(d)

pre.period <- as.Date(c("2012-11-01", "2013-06-01"))
post.period <- as.Date(c("2013-06-02", "2013-06-30"))

impact <- CausalImpact(d, pre.period, post.period)
plot(impact)

