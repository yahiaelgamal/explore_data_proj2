

## This first line will likely take a few seconds. Be patient!
summ = readRDS("summarySCC_PM25.rds")
classi = readRDS("Source_Classification_Code.rds")

#q
years_poll = tapply(summ$Emissions, summ$year, sum)

png('plot1.png')
plot(names(years_poll), years_poll, type='l', main="Emissions Over Years", xlab="Year", ylab="Emissions")
dev.off()
