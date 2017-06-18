d <- read.csv("train.csv",na.strings='NULL')
data_100 <- read.csv("xaa.csv",na.strings= 'NULL')

### 1 and 0 half data

data_1 <- filter(d,booking_bool == 1)
data_0 <- filter(d,booking_bool == 0)
data_0_sample <- sample_n(data_0, 276593)
data_half <- bind_rows(data_0_sample,data_1)

write.csv(data_half, file="data_half.csv", row.names = F, quote = F,fileEncoding = "big5")

###


data <- d[,-3:-51]
data$date_time <-substr(data[,2],0,10) 
data[is.na(data)] <- 0
library(dplyr)
group_by(data, date_time) %>% 
  summarise(mean=mean(visitor_location_country_id)) -> tmp

write.csv(tmp, file="tmp.csv", row.names = F, quote = F,fileEncoding = "big5")

library(ggplot2)
library(dplyr)
library(reshape2)
tmp[1:60,]

tmp %>% 
  ggplot(aes(x=date,y=sum,group=1)) +
  geom_line() +  labs(x = "date" , y = "sum")+ coord_flip()

# arrange(data, date_time)
# aggregate(data$gross_bookings_usd, by=list(Category=data$date), FUN=sum) %>% head

### 月份營收總和

sum_usd_mon <- read.csv("sum_usd.csv",header=T,na.strings=c('NA',''))
sum_usd_mon$date <- substr(sum_usd_mon$date,0,7) 
group_by(sum_usd_mon, date) %>% 
  summarise(sum=sum(sum)) -> tmp

write.csv(tmp, file="sum_usd_mon.csv", row.names = F, quote = F,fileEncoding = "big5")

