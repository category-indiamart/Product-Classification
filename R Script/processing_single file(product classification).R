library(psych)
library("readxl")
library("xlsx")
library("stringr")
library("stringi")
library("dplyr")
library("stopwords")
library("tm")
library("qdapRegex")
#?qdapRegex
df<- readxl::read_excel("E:/Ayush_PC/9_pmcats_bl_data.xlsx",sheet = 1)


#gsub("\\.","","i am a . dggf.f")
#df1 <- df[,c(1:4,6,14,15)] 
df1 <- df
df1$testing <- df1$Label1
df1$testing <- rm_white(df1$testing) #to remove multiple white spaces with single space
#df1$testing <- gsub(" ","",df1$testing)
df1$testing <- gsub("[0-9]\\w+ *", "",df1$testing)
df1$testing <- gsub("[0-9] \\w+ *", "",df1$testing)
df1$testing <- gsub("\\.","",df1$testing)
df1$testing <- gsub("[[:punct:]]","",df1$testing)
df1$testing <- gsub("-","",df1$testing)
df1$testing <- gsub(",","",df1$testing)
#df1$testing <- gsub("[:digit:]","",df1$testing)
df1$testing <- gsub("[0-9]","",df1$testing)
#df1$testing <- rm_white(df1$testing)
#index <- grepl("\\d",df1$testing)
#removing duplicate words:
rem_dup.one <- function(x){
  x <- tolower(x)
  paste(unique(trimws(unlist(strsplit(x,split=" ",fixed=F,perl=T)))),collapse = " ")
}

df1$testing <- lapply(df1$testing,rem_dup.one)
df1$testing <- as.character(df1$testing)
df1$testing <- gsub("NA","",df1$testing)

df1$ETO_OFR_TITLE1 <- tolower(df1$ETO_OFR_TITLE)
df1$fasttextTest <- paste0(df1$ETO_OFR_TITLE1," ",df1$testing)
df1$fasttextTest <- gsub("[0-9]\\w+","",df1$fasttextTest)
df1$fasttextTest <- gsub("[0-9] \\w+","",df1$fasttextTest)
df1$fasttextTest <- gsub("[0-9]","",df1$fasttextTest)
df1$fasttextTest <- gsub("-","",df1$fasttextTest)
df1$fasttextTest <- gsub("&","",df1$fasttextTest)
df1$fasttextTest <- gsub("/","",df1$fasttextTest)
df1$fasttextTest <- gsub("%","",df1$fasttextTest)
df1$fasttextTest <- gsub(" o ","",df1$fasttextTest)
#df1$fasttextTest <- gsub("[:punct:]","",df1$fasttextTest)
testingbl1 <- df1$fasttextTest


write.table(testingbl1,"E:/Ayush_PC/930_bl_testing.txt",sep = "\t",row.names = F,col.names = F,quote = F)

#writting for vlookup
df_vlookup <- df1[,c(1:4,20)]
write.csv(df_vlookup,"E:/BL-Audit/Excavator/vlookup_excavator_blbrand.csv",row.names = F,quote = F)
#=================================TRAINING FILE CREATED===================================#

#processing output file:
{
  
j <- 5

locations <- paste0("E:/Conduit/pmcat_final.csv")

df <- read.csv(locations,header = F)
#df <- readxl::read_excel(locations,sheet = 1,col_names = F)
df <- data.frame(df[,1])
colnames(df)
colnames(df)[colnames(df)=="df...1."] <- "V1"

index <- seq(1,nrow(df),2)

length <- nrow(df)
#Creating two empty dataframes
my_df<-data.frame(df.i...=character()) 
my_df1<-data.frame(df.i...=character())

for(i in seq(from=1,to=length,by=2)){
  
  a<-data.frame(df[i,])
  b<-data.frame(df[i+1,])
  my_df<-rbind(my_df,a)
  my_df1<-rbind(my_df1,b)
}
# Creating a dataframe new_df by joining two dataframe my_df and my_df1
new_df<-cbind(my_df,my_df1)
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

# Extracting thirdd Column
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
location2 <- paste0("E:/Conduit/pmcat_final",j,".csv")
write.csv(final_out,location2,row.names = F,quote = F)

}

#newdf_var <- newdf4
#V1<-c('Standard','Variant','Standard','Standard','Variant','Variant')
#V2<-c('LG Mobile 500X','GX 500 Ultra','LG Mobile 500X','Mi Mobile Phone','redmi 5A','redmi 5A')

#res1<-as.data.frame(cbind(V1,V2))
#data<-res1
#data[which(duplicated(data[,c]))]

#index<-which(duplicated(data[,c('V1','V2')])==T)
