data <- read.csv("data_half.csv")
d <- read.csv("train.csv",header=T,na.strings=c('NA'),stringsAsFactors=FALSE)



data[is.na(data)] <- 0

d[is.na(d[,1:54])] <- 0

write.csv(data_50000, file="train_50000.csv", row.names = F, quote = F,fileEncoding = "big5")

data_less <- data[,c(-2,-52:-53)]

data_50000 <- sample_n(d, 50000)

sample_n(data_less, 1000)

am.glm <- glm(formula = booking_bool ~ ., data = data_less , family='binomial')

step(am.glm)

am.glm1 <- glm(formula = booking_bool ~ visitor_hist_starrating + prop_country_id + 
                 prop_starrating + prop_review_score + prop_brand_bool + 
                 prop_location_score1 + prop_location_score2 + prop_log_historical_price + 
                 position + promotion_flag + 
                 srch_length_of_stay + srch_booking_window + srch_adults_count + 
                 srch_children_count + srch_room_count + 
                 srch_query_affinity_score + random_bool + 
                 comp2_rate + 
                 comp3_rate + 
                 comp4_rate + 
                 comp5_rate + comp5_inv + comp6_rate + 
                 comp7_rate + comp7_inv + 
                 comp8_rate , data = data_less , family='binomial')

book.glm <-glm(Origin~Price+Type+MPG.city+ MPG.highway+ AirBags+ DriveTrain +EngineSize+ Horsepower+ RPM
    +Rev.per.mile+Man.trans.avail+Fuel.tank.capacity+Passengers+Length+Wheelbase+Width+Turn.circle+Rear.seat.room
    +Luggage.room+Weight,family='binomial',data=Cars93)

