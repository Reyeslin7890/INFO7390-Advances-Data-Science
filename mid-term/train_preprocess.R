library(xlsx)
setwd('D:/NEU/7390 Advances Data Science/midterm')
file <- "application_train.csv"
df <- read.csv(file,1)

#Missing Data Columns
df[is.na(df["AMT_ANNUITY"]),"AMT_ANNUITY"] <- min(df["AMT_ANNUITY"],na.rm=T)
df[is.na(df["AMT_GOODS_PRICE"]),"AMT_GOODS_PRICE"] <-  df[is.na(df["AMT_GOODS_PRICE"]),"AMT_CREDIT"]
df[is.na(df["OWN_CAR_AGE"]),"OWN_CAR_AGE"] <- min(df["OWN_CAR_AGE"],na.rm=T)
df[is.na(df["CNT_FAM_MEMBERS"]),"CNT_FAM_MEMBERS"] <- 0
df[is.na(df["TOTALAREA_MODE"]),"TOTALAREA_MODE"] <- 0
df[is.na(df["DAYS_LAST_PHONE_CHANGE"]),"DAYS_LAST_PHONE_CHANGE"] <- min(df["DAYS_LAST_PHONE_CHANGE"],na.rm=T)
# "DAYS_EMPLOYED" column: 365243 -> 0
df[df['DAYS_EMPLOYED'] == 365243,'DAYS_EMPLOYED'] <- 0
levels(df[,'OCCUPATION_TYPE']) <- c(levels(df[,'OCCUPATION_TYPE']),"Unemployed")
df[df['OCCUPATION_TYPE']=="",'OCCUPATION_TYPE'] <- "Unemployed"


for (col in c("EXT_SOURCE_1","EXT_SOURCE_2","EXT_SOURCE_3")) df[is.na(df[col]),col] <- mean(df[!is.na(df[col]),col])

#"_AVG" columns
for (col in colnames(df[,45:58])) df[is.na(df[col]),col] <- 0
#"_MODE" columns
for (col in colnames(df[,59:72])) df[is.na(df[col]),col] <- 0
#"_MEDI" columns
for (col in colnames(df[,73:86])) df[is.na(df[col]),col] <- 0
#"DPD" columns
for (col in colnames(df[,92:95])) df[is.na(df[col]),col] <- 0
#"AMT_REQ_CREDIT_BUREAU" columns
for (col in colnames(df[,117:122])) df[is.na(df[col]),col] <- 0


#Binary Columns
df$CODE_GENDER <- as.numeric(df$CODE_GENDER)-1
df$NAME_CONTRACT_TYPE <- as.numeric(df$NAME_CONTRACT_TYPE)-1
df$FLAG_OWN_CAR <- as.numeric(df$FLAG_OWN_CAR)-1
df$FLAG_OWN_REALTY <- as.numeric(df$FLAG_OWN_REALTY)-1

#Categorical Columns
#install.packages("reshape2")
library(reshape2)
fac <- sapply(df, is.factor)
#fac["ORGANIZATION_TYPE"] <- FALSE
df.other <- df[,!fac]
df.factor <- cbind(df["SK_ID_CURR"],df[,fac])
df.factor <- dcast(melt(df.factor, id.vars = "SK_ID_CURR"), SK_ID_CURR ~ variable + value, fun = length)
names(df.factor)[names(df.factor)=="NAME_TYPE_SUITE_"] <- "NAME_TYPE_SUITE_Unknown"
names(df.factor)[names(df.factor)=="FONDKAPREMONT_MODE_"] <- "FONDKAPREMONT_MODE_Unknown"
names(df.factor)[names(df.factor)=="HOUSETYPE_MODE_"] <- "HOUSETYPE_MODE_Unknown"
names(df.factor)[names(df.factor)=="WALLSMATERIAL_MODE_"] <- "WALLSMATERIAL_MODE_Unknown"
names(df.factor)[names(df.factor)=="EMERGENCYSTATE_MODE_"] <- "EMERGENCYSTATE_MODE_Unknown"
df <- cbind(df.other, df.factor[,2:ncol(df.factor)])

write.csv(df,"application_train_preprocessed.csv",row.names=FALSE)
