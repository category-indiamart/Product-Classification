# processing final data:
#options(scipen = 999)
#options("scipen"=100, "digits"=4)
#format(1810032000, scientific = FALSE)
library(psych)
library("readxl")
library("xlsx")
library("stringr")
library("stringi")
library("dplyr")
library("stopwords")
library("tm")
library("qdapRegex")
j <- 3

for (j in 1:10) {
  
locations <- paste0("E:\\Product Classification_new\\Skid Steer\\Brand\\final/",j,".csv")

df <- read.csv(locations,header = F,sep = ",",fill = T)
df <- data.frame(df[,"V1"])
sum(df$V1=="")
    
index <- seq(1,nrow(df),2)

length <- nrow(df)
#Creating two empty dataframes
my_df<-data.frame(df.i...=character()) 
my_df1<-data.frame(df.i...=character())
#df<-df[-c(10060,13358),]
#df<-data.frame(df)
for(i in seq(from=1,to=length,by=2)){
 
  a<-data.frame(df[i,])
  b<-data.frame(df[i+1,])
  my_df<-rbind(my_df,a)
  my_df1<-rbind(my_df1,b)
}
# Creating a dataframe new_df by joining two dataframe my_df and my_df1
new_df<-cbind(my_df,my_df1)
#new_df <- new_df[-nrow(new_df),]
# renaming columns
new_df<-rename(new_df,V1=df.i...)
new_df<-rename(new_df,V2=df.i...1...)
#new_df<-data.frame(paste0(new_df$V1," ",new_df$V2))
#new_df<-rename(new_df,V1=paste0.new_df.V1.......new_df.V2.)

#colnames(new_df)[names(new_df)=="df.i..."] <- V1


#splitting word data:
# removing last comma character from column
char_array <-new_df$V2
a <-data.frame("data"=char_array,"data2"=1)
a$data<-as.character(a$data)
new_df$V2 = substr(a$data,1,nchar(a$data)-1)

#Extracting rating based on whitespace as delimiter
new_df$rating2<-word(new_df$V2,-1)

# Extracting label
new_df$mcat1<-word(new_df$V2,-4)
new_df$mcat1 <- gsub("__label__","",new_df$mcat1)
new_df$mcat1 <- gsub("_"," ",new_df$mcat1)

# Extracting second mcat_match
new_df$mcat2<-word(new_df$V2,-2)
# Replacing __label__ with empty
new_df$mcat2<-gsub("__label__", "", new_df$mcat2)
new_df$mcat2 <- gsub("_"," ",new_df$mcat2)
#new_df$third<-gsub("_", " ", new_df$third)
new_df$rating1 <- word(new_df$V2,-3)

final_out <- new_df[,c(1,2,4,6,5,3)]
final_out <- rename(final_out,test_data=V1)
final_out[2,]
index <- grepl("e",final_out$rating2)
#index <- as.character(index)
for (i in 1:nrow(final_out)) {
  ifelse(index[i]==TRUE,final_out$rating2[i] <- 0,final_out$rating2[i] <- as.numeric(final_out$rating2[i]))
}
#final_out$rating2 <- format(final_out$rating2,scientific = FALSE)
#options(digits = 22)
#library(bit64)
#inal_out$rating2 <- as.integer64(final_out$rating2)
#as.integer()
#write_csv(tbl_df,'test.csv')
location2 <- paste0("E:\\Product Classification_new\\Skid Steer\\Brand\\final/skid_steer_Brand",j,".csv")
write.csv(final_out,location2,row.names = F,quote = F)

}
