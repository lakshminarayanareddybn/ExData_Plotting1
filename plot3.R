#Check for and load required packages
if(!require(plyr)) install.packages("plyr")
library(plyr)
if(!require(graphics)) install.packages("graphics")
library(graphics)
if(!require(data.table)) install.packages("data.table")
library(data.table)
if(!require(grDevices)) install.packages("grDevices")
library(grDevices)

#Check for and create folder to store data
if (!file.exists("Data"))
  dir.create("Data")

#Check if data has already been downloaded to above folder
#If not, download data
if (!file.exists("Data/household_power_consumption.zip")){
  #Define URL to download data from
  url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  #Download data to folder
  #This may take some time since size of data is ~ 20MB
  download.file(url, "Data/household_power_consumption.zip")
}

#Since the downloaded data is in a zip file, first extract it and then import only required rows
power_cons<-read.table(unz("Data/household_power_consumption.zip", "household_power_consumption.txt"),sep=";",skip=66637,nrows=2880,na.strings="?",col.names=c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#Create new column for datetime using date and time columns, convert to POSIXlt
power_cons$DateTime=paste(power_cons$Date,power_cons$Time)
power_cons$DateTime<-strptime(power_cons$DateTime,format="%d/%m/%Y %H:%M:%S")

#Plot plot3 and save to file
png(filename="plot3.png",width=480,height=480,units="px")
with(power_cons,plot(DateTime,Sub_metering_1,ylab="Energy sub metering",xlab="",type="n"))
with(power_cons,lines(DateTime,Sub_metering_1))
with(power_cons,lines(DateTime,Sub_metering_2,col="red"))
with(power_cons,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1)
dev.off()