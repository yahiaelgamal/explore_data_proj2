
## This first line will likely take a few seconds. Be patient!
summ = readRDS("summarySCC_PM25.rds")
classi = readRDS("Source_Classification_Code.rds")

#q
years_poll = tapply(summ$Emissions, summ$year, sum)

png('plot1.png')
plot(names(years_poll), years_poll, type='l', main="Emissions Over Years", xlab="Year", ylab="Emissions")
dev.off()


# ----

 

summ.balti = summ[summ$fips == '24510', ]
years_poll.balti = tapply(summ.balti$Emissions, summ.balti$year, sum)

png('plot2.png')
plot(names(years_poll.balti), years_poll.balti, type='l', main="Emissions Over Years (Baltimore)", xlab="Year", ylab="Emissions")
dev.off()


# ---- 3

library(ggplot2)
library(plyr)

summ$type_f = factor(summ$type)
summ.df = ddply(summ, .(type_f, year), summarize, SUM = sum(Emissions), 2)

png('plot3.png')
qplot(summ.df$year, summ.df$SUM, color=summ.df$type_f, geom='path', main="Emissions By Year and Type")
dev.off()


# --------
coal_scc = classi[grep('[cC]oal', classi$SCC.Level.Three),]$SCC
coal = summ[summ$SCC %in% coal_scc,]
coal_sum = ddply(coal, .(year), summarize, Emissions=sum(Emissions))
png('plot4.png')
qplot(coal_sum$year, coal_sum$Emissions, geom='path', main="Coal-Realted Emissions")
dev.off()

# ---
motor_scc = classi[grep('[mM]tor', classi$SCC.Level.Three),]$SCC
motor = summ.balti[summ.balti$SCC %in% motor_scc,]
motor_sum = ddply(motor, .(year), summarize, Emissions=sum(Emissions))
png('plot5.png')
qplot(motor_sum$year, motor_sum$Emissions, geom='path', main="Motor-Realted Emissions (Baltimore)")
dev.off()

#---
motor_la_ba = summ[summ.balti$SCC %in% motor_scc,]
motor_la_ba = motor_la_ba[motor_la_ba$fips == '24510' | motor_la_ba$fips == '06037', ]
motor_la_ba$state = ifelse(motor_la_ba$fips == '24510', 'Baltimore', 'LA')

motor_la_ba = ddply(motor_la_ba, .(year, state), summarize, Emissions = sum(Emissions))

png('plot6.png')
qplot(motor_la_ba$year, motor_la_ba$Emissions, color=motor_la_ba$state, geom='path', main="Motor-Related Emission (Blatimore/LA)")
dev.off()
