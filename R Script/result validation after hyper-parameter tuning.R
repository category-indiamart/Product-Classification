
k <- 1
Check <- data.frame(Var1 = numeric(),
                    Freq = numeric())


for (k in 1:10) {
   df <- readxl::read_excel("E:/Product Classification_new/NPS/Child1/Tuned_out/Tuned_final/processed.xlsx",sheet = k)
  df2 <- df[!is.na(df$`Category Suggestion`),]
  df2 <- df2[-nrow(df2),]
  df2$rating1 <- as.numeric(df2$rating1)
  df3 <- df2[df2$rating1>mean(df2$rating1,na.rm = T),]
  df3$Match <- df3$`Category Suggestion`==df3$mcat1
  
  Var1 <- table(df3$Match)
  var2 <- prop.table(Var1)
  Var2 <- as.data.frame(var2)
  Var2 <- Var2[-1,]
  Check <- rbind(Check,Var2)
  #Check <- Check[Check$Var1=="TRUE",]
  
}

lr <- seq(0.1,1,by=0.1)
Check$LR <- lr
Check2 <- Check[,-1]
fix(Check2)
Check2
Plot <- ggplot(data = Check2)

Plot <- Plot + aes(x=LR,y=Accuracy) +xlim(0.2,1.0) +ylim(0.87,0.927)

Plot <- Plot + geom_point() +geom_line(color ="tomato",size =1)

Plot 
 