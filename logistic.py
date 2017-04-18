#!/usr/bin/env python
# -*- coding: utf-8 -*-
import math
from time import time
import numpy as np
from pyspark import SparkConf, SparkContext
from pyspark.mllib.classification import LogisticRegressionWithLBFGS, LogisticRegressionModel
from pyspark.mllib.tree import DecisionTree
from pyspark.mllib.regression import LabeledPoint
from pyspark.mllib.evaluation import RegressionMetrics


def SetLogger(sc):
    logger = sc._jvm.org.apache.log4j
    logger.LogManager.getLogger("org"). setLevel(logger.Level.ERROR)
    logger.LogManager.getLogger("akka").setLevel(logger.Level.ERROR)
    logger.LogManager.getRootLogger().setLevel(logger.Level.ERROR)


def extract_label(record):
    label = record[-1]
    return float(label)


def convert_float(x):
    return 0 if x == "NULL" else float(x)


def extract_features(record):
    features_index = [3, 4, 5, 14, 15, 16, 25]
    features = [convert_float(record[x]) for x in features_index]
    return np.asarray(features)



def prepare_data(sc):
    print("開始匯入資料...")
    rawDataWithHeader = sc.textFile("/Users/yangminglin/data/xaa.csv")
    header = rawDataWithHeader.first()
    rawData = rawDataWithHeader.filter(lambda x: x != header)
    lines = rawData.map(lambda x: x.split(","))
    print (lines.first())
    print("共計：" + str(lines.count()) + "筆")
    labelpointRDD = lines.map(lambda r: LabeledPoint(extract_label(r), extract_features(r)))
    (trainData, validationData,
     testData) = labelpointRDD.randomSplit([8, 1, 1])
    print("將資料分trainData:" + str(trainData.count()) +
          "validationData:" + str(validationData.count()) +
          "testData:" + str(testData.count()))
    return (trainData, validationData, testData)

def parsePoint(line):
    values = [float(x) for x in line.split(' ')]
    return LabeledPoint(values[0], values[1:])

def CreateSparkContext():
    sparkConf = SparkConf()   \
        .setAppName("RunDecisionTreeClassficaiton") \
        .set("spark.ui.showConsoleProgress", "false")
    sc = SparkContext(conf=sparkConf)
    print ("master=" + sc.master)
    SetLogger(sc)
    return (sc)


def trainEvaluateModel(trainData):
    model = LogisticRegressionWithLBFGS.train(trainData)
    return model


def evaluateModel(model, validationData):
    score = model.predict(validationData.map(lambda p: p.features))
    '''labelsAndPredictions = validationData.map(lambda p: p.label).zip(score)'''
    labelsAndPreds = validationData.map(lambda p: (p.label, model.predict(p.features)))
    testErr = labelsAndPreds.filter(lambda (v, p): v != p).count() / float(validationData.count())
    print('Test Error = ' + str(testErr))
''' print('Learned classification tree model:')
    print(model.toDebugString()) '''




def predictData(sc, model):
    #----------------------1.匯入並轉換資料-------------
    print("開始匯入資料...")
    rawDataWithHeader = sc.textFile("/Users/yangminglin/data/xaa.csv")
    header = rawDataWithHeader.first()
    rawData = rawDataWithHeader.filter(lambda x:x !=header)
    lines = rawData.map(lambda x: x.split(","))
    print("共計：" + str(lines.count()) + "筆")
    #----------------------2.建立訓練評估所需資料 LabeledPoint RDD-------------
    labelpointRDD = lines.map(lambda r: LabeledPoint(extract_label(r), extract_features(r)))
    
    #----------------------4.進行預測並顯示結果--------------

    # 把預測結果寫出來
    f = open('workfile', 'w')
    for lp in labelpointRDD.take(10000):
        predict = int(model.predict(lp.features))
        dataDesc = "  " + str(predict) + " "
        f.write(dataDesc)
    f.close()


if __name__ == "__main__":
    sc = CreateSparkContext()
    (trainData, validationData, testData) = prepare_data(sc)
    trainData.persist()
    validationData.persist()
    testData.persist()
    data = sc.textFile("/Users/yangminglin/data/xaa.csv")
    model = trainEvaluateModel(trainData)
    evaluateModel(model, testData)
    predictData(sc, model)