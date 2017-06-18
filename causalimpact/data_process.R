DEXUSEU <- read.csv("DEXUSEU.csv",header=T,na.strings=c('NA'),stringsAsFactors=FALSE)
DEXUSEU_1 <- as.numeric(DEXUSEU[,2])
DEXUSEU_1[is.na(DEXUSEU_1)] <- 0
DEXUSEU$DEXUSEU <- DEXUSEU_1

for (i in 1:1305){
  if (is.na(DEXUSEU[i,2])){
    as.integer(DEXUSEU[i,2])
    DEXUSEU[i,2]<- 0
  } 
}

DEXUSEU_2012_11 <- DEXUSEU[109:280,]

colnames(DEXUSEU_2012_11)[colnames(DEXUSEU_2012_11)=="DATE"] <- "date"

for(i in 1:172){
  if( DEXUSEU_2012_11[i,2] == 0){
    DEXUSEU_2012_11[i,2] <- DEXUSEU_2012_11[i-1,2]
  }
}

final <- merge(x = sum_usd, y = DEXUSEU_2012_11, by = "date", all = TRUE)

for(i in 1:242){
  if( is.na(final[i,3])){
    final[i,3] <- final[i-1,3]
  }
}

####### Main causul
library(CausalImpact)
sum_usd <- read.csv("sum_usd.csv",header=T,na.strings=c('NA',''))
aal_stock_price_data <- read.csv("aal_stock_price_data.csv",header=F,na.strings=c('NA'),stringsAsFactors=FALSE)


y <- as.numeric(final[,2])
x1 <-as.numeric(final[,3]) 
data <- cbind(y, x1)

matplot(data, type = "l")

time.points <- seq.Date(as.Date("2012-11-01"), by = 1, length.out = 242)
data <- zoo(cbind(y, x1), time.points)
head(data)

pre.period <- as.Date(c("2012-11-01", "2013-04-01"))
post.period <- as.Date(c("2013-04-02", "2013-06-30"))

impact <- CausalImpact(data, pre.period, post.period)
plot(impact)

### 月份營收總和

RSAFS <- read.csv("RSAFS.csv",header=T,na.strings=c('NA'),stringsAsFactors=FALSE)


AIRRPMTSI <- read.csv("AIRRPMTSI.csv",header=T,na.strings=c('NA'),stringsAsFactors=FALSE)


RSAFS_201211 <- RSAFS[251:258,]

AIRRPMTSI_201211 <- AIRRPMTSI[155:162,]

tmp$date <- RSAFS_201211$DATE

sum_mon <- apply(tmp[,2],2,as.numeric)

y <- as.numeric(sum_mon)
x1 <-as.numeric(AIRRPMTSI_201211[,2]) 
x2 <- as.numeric(RSAFS_201211[,2]) 
data <- cbind(y, x1)

matplot(data, type = "l")

time.points <- seq.Date(as.Date("2012-11-01"), by = "month", length.out = 8)
data <- zoo(cbind(y, x1), time.points)
head(data)

pre.period <- as.Date(c("2012-11-01", "2013-02-01"))
post.period <- as.Date(c("2013-03-01", "2013-06-01"))

impact <- CausalImpact(data, pre.period, post.period,model.args = list(niter = 5000, nseasons = 7))
impact <- CausalImpact(data, pre.period, post.period)
plot(impact, c("original", "pointwise"))
plot(impact)
