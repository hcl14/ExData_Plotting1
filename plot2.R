##### Read specified strings from file ##########################################

## usage of grep is a bit unix-specific
## Windows users should either install grep or try something like
## findstr /B /R ^[1-2]/2/2007 household_power_consumption.txt"
m<-read.csv(pipe('grep "^[1-2]/2/2007" "household_power_consumption.txt"'),sep=";", header=F)
## finally transform all the data needed to numeric and Date type

m[,3:9] <- sapply(m[,3:9], as.numeric)

## Let's save the full time for the future, but have the date separately too
m[,2]<-as.POSIXct(mapply(paste, m[,1], m[,2]), format="%d/%m/%Y%H:%M:%S") 
## we combine string values from first two colums
## and convert them to the POSIXct format
m[,1]<-as.Date(m[,1], format="%d/%m/%Y")

## Obtaining column names from file
con <- file("household_power_consumption.txt", "r", blocking = FALSE) ##create file connection
d=scan(con,what="a",nlines=1,sep=";") ##read the header line
colnames(m)<-d
close(con) ## close file connection


##############################################################################


## Plot for 'Global_active_power' against time

## If the weekdays are not in English do Sys.setlocale("LC_TIME", "C")
plot(m[,2], m$Global_active_power, type="l", xlab = "",
  ylab="Global Active Power (kilowatts)",cex.lab=0.8, cex.axis=0.8, cex.main = 0.9, mgp = c(2, 0.8, 0))
## axis labes and main are a little bit smaller; labels are closer to plot
