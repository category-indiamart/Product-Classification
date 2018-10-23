
# select the path where MCAT level testing file to be created.
MCAT_testing_path <- choose.dir()

dir.create(paste0(MCAT_testing_path,"/Testing Files"),showWarnings = F)


#reading processed data where PMCAT prediction done.

df <- readxl::read_excel("C:/Users/indiamart/Desktop/Office Chair/PMCAT level.xlsx",sheet = 2)

df <- df[order(df$mcat1),]

out <- split(df,f=df$mcat1)

for (i in 1:length(out)) {
  hold <- unique(out[[i]]$mcat1)
  Locc2 <- paste0(MCAT_testing_path,"/Testing Files/",hold,".txt")
  a <- out[[i]]$test_data
  write.table(out[[i]]$test_data,Locc2,row.names = F,col.names = F,quote = F)
}