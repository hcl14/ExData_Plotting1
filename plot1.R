##### Read specified strings from file ##########################################

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


## Plotting histogram for 'Global_active_power'

hist(m$Global_active_power, breaks = 12, xlab= "Global Active Power (kilowatts)", ylab="Frequency", 
     main = "Global Active Power", freq=TRUE, col = "red", cex.lab=0.8, cex.axis=0.8, cex.main = 0.9, mgp = c(2, 0.8, 0))
# number of breaks = 12, histrogram for frequencies (freq=TRUE) and fonts for axis, 
## axis labes and main are a little bit smaller; labels are closer to plot
