##### Read specified strings from file ##########################################

## I know about the way that uses library(sqldf) but it becomes complicated for me to deal with the dates in format dd/mm/YYYY

first_date <- "2007-02-01" 
second_date <- "2007-02-03" ## ! required date + 1 day !

con <- file("household_power_consumption.txt", "r", blocking = FALSE) ##create file connection
d=scan(con,what="a",nlines=1,sep=";") ##read the header line
d = matrix(d,nrow=1) ## we want d's as rows
m<-as.data.frame( ##create empty data frame
  matrix(nrow = 0, ncol = 9,
         dimnames = list(NULL, d))) ## assign d as column names

myDate<-as.POSIXct("1980-02-01") ## we don't want to wait until EOF, so we add date check

d=scan(con,what="a",nlines=1,sep=";",quiet=TRUE) ## Read 1 line from file, separating it into vector of strings

while((length(d) > 0) && (myDate<as.POSIXct(second_date))) { ## EOF and Date check
  
  #Do stuff with d....
  myDate<-as.POSIXct(d[1], format="%d/%m/%Y") ## read the date in the format that allows comparsion
  if ((myDate >= as.POSIXct(first_date)) && (myDate < as.POSIXct(second_date))){ ## Looks like as.POSIXct("2007-02-02") = as.POSIXct("2007-02-02 00:00:00")
    ## so we will lose 2007-02-02 data if we write myDate <= as.POSIXct("2007-02-02")
    
    
    
    #     d = matrix(d,nrow=1) ## converting chr's to factors
    #     d = data.frame(d) 
    #     colnames(d)<-colnames(m) ##rbind is messing up the column names 
    #     m = rbind(m,d) ## adding new line to a data frame    
    
    m[nrow(m)+1,]<-d  ## we will leave data as character    
    
  }
  
  d=scan(con,what="a",nlines=1,sep=";",quiet=TRUE) ## Read 1 line from file, separating it into vector of strings
}
close(con) ## close file connection

## finally transform all the data needed to numeric and Date type

m[,3:9] <- sapply(m[,3:9], as.numeric)

## Let's save the full time for the future, but have the date separately too
m[,2]<-as.POSIXct(mapply(paste, m[,1], m[,2]), format="%d/%m/%Y%H:%M:%S") ## we combine string values from first two colums
## and convert them to the POSIXct format
m[,1]<-as.Date(m[,1], format="%d/%m/%Y")


##############################################################################


## Plot for 'Global_active_power' against time

## If the weekdays are not in English do Sys.setlocale("LC_TIME", "C")
plot(m[,2], m$Global_active_power, type="l", xlab = "",ylab="Global Active Power (kilowatts)",cex.lab=0.8, cex.axis=0.8)
