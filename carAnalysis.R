library(reshape2)
library(tidyr)
library(dplyr)
library(ggplot2)

#1.read the data
df=read.csv("CARS.csv")
#2.first 10 data

head(df,10)
#3.last 10 data

tail(df,10)

#3. shape of data

dim(df)
#4.print all col names
colnames(df)
#5.datatype of the columns
str(df)


#6. print information and summary

summary(df)
#7 find null values

sum(is.na(df))
# there are a total of 2 null values 2 in cylinders column
# filling the missing values with 4 as the horse power of the missing values is higher.
df[is.na(df$Cylinders),]$Cylinders<-4
sum(is.na(df))


#8.visualisations
#a. relationships between origin and type.

df$Invoice=gsub('[$]','',df$Invoice)
df$Invoice=as.numeric(gsub(',','',df$Invoice))
g<-ggplot(df,aes(x=Origin,y=Invoice))+stat_boxplot(aes(colour=Origin))
g+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+facet_grid(Origin~Type)
g

#b.the following plot shows the count of car price by type
g<-ggplot(df,aes(x=Invoice))+geom_histogram(binwidth = 5000,aes(fill=Type))
g<-g+facet_wrap(~Type)+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
g


g<-ggplot(df,aes(x=Invoice))+geom_density(kernel="gaussian",aes(fill=Origin))
g<-g+facet_wrap(~Origin)+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
g

#the following plot shows frequency of car types by Origin
g<-ggplot(df,aes(x=Origin))+geom_bar(aes(fill=Type),position="dodge")
g+theme_gdocs()+scale_fill_gdocs()

#the following plot shows the correlation between engine size and the car's price, by car types
g<-ggplot(df,aes(x=EngineSize, y=Invoice))+geom_point(aes(colour=Type,shape=Origin))
g+facet_wrap(~Type)+geom_smooth(method = "lm",se=FALSE)



#9. plot the bargraph of make of the car with frequency.
ggplot(df,aes(x=Make)+geom_bar(position = "dodge")+
         labs(title="Make of the Car")+
         coord_flip()+
         geom_text(stat="count",aes(label=stat(count),vjust=-0)))
#10.plot the bar graph for type of the car 

g<-ggplot(df,aes(x=Type)+geom_bar(aes(fill=DriveTrain),position="dodge"))
g+theme_gdocs()+scale_fill_gdocs()
g

#11. plot the graph for most sales for cars by location

ggplot(df,aes(x=Origin,fill=Origin))+geom_bar(position = "dodge")+
  labs(title="LOCATION OF CAR SALES")+
  geom_text(stat="count",aes(label=stat(count),vjust=-0.5))



