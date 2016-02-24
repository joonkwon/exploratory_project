# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# sum of emissions by year to variable total
total <- tapply(pm25$Emissions, pm25$year, sum, na.rm=TRUE)

# define color for bar graph
color <- rgb(0,0,1, alpha=0.3)
# draw bargrpah using base barplot
barplot(total, col=color, xlab="Year", ylab="PM25 Emission (ton)", 
        border="red", main="Total PM25 Emission" )
# save as png file
dev.copy(png, filename="plot1.png", width=480, height=480)
dev.off()