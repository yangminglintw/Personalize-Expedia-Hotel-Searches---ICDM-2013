Sys.setenv(SPARK_HOME = "/Users/yangminglin/spark-2.1.0-bin-hadoop2.7")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sparkR.session(master="local[*]")

data <- read.csv("data_half.csv")
ddf <- createDataFrame(data)

data2 <- read.csv("hour.csv")
df <- createDataFrame(data2)


seed <- 12345
training_ddf <- sample(ddf, withReplacement=FALSE, fraction=0.7, seed=seed)
test_ddf <- except(ddf, training_ddf)

model <- spark.randomForest(training_ddf, click_bool ~ ., type="classification", seed=seed,numTrees = 10)

model <- spark.logit(training_ddf, booking_bool ~ . , maxIter = 10, regParam = 0.3, elasticNetParam = 0.8)

predictions <- predict(model, training_ddf)
prediction_df <- collect(select(predictions, "gross_bookings_usd", "prediction"))

medals <- loadDF("/Users/yangminglin/Google 雲端硬碟/Graduate/1052/BigData/Project/data/xaa.csv",source = "csv",header="true")
model <- spark.logit(medals, click_bool ~ ., regParam = 0.5)
model <- spark.glm(medals, click_bool ~ price_usd + date_time, family = "gaussian")


irisDF <- suppressWarnings(createDataFrame(iris))
gaussianDF <- irisDF
gaussianTestDF <- irisDF
gaussianGLM <- spark.glm(gaussianDF, Sepal_Length ~ Sepal_Width + Species, family = "gaussian")
