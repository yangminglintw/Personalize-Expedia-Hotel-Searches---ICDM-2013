data <- read.csv("data_half.csv")
d <- read.csv("train.csv",na.strings='NULL')

data[is.na(data)] <- 0

write.csv(data, file="data_half_0.csv", row.names = F, quote = F,fileEncoding = "big5")

data_less <- data[,c(-2,-52:-53)]

data_1000 <- sample_n(data_less, 1000)

sample_n(data_less, 1000)

am.glm <- glm(formula = booking_bool ~ ., data = data_1000 , family='binomial')

step(am.glm)

book.glm <-glm(Origin~Price+Type+MPG.city+ MPG.highway+ AirBags+ DriveTrain +EngineSize+ Horsepower+ RPM
    +Rev.per.mile+Man.trans.avail+Fuel.tank.capacity+Passengers+Length+Wheelbase+Width+Turn.circle+Rear.seat.room
    +Luggage.room+Weight,family='binomial',data=Cars93)

