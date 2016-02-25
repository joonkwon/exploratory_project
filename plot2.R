# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# subset only baltimore data
pm25_baltimore <- subset(pm25, pm25$fips == "24510")
# calculate yearly total for baltimore data
pm25_bal_total <- tapply(pm25_baltimore$Emissions, pm25_baltimore$year, sum, na.rm=TRUE)

# draw bar graph
color <- rgb(0,0,1, alpha=0.3)
barplot(pm25_bal_total, col=color, xlab="Year", ylab="Total PM25 Emission (ton)", 
        border="red", main="Total PM2.5 Emission in Baltimore")

dev.copy(png, "plot2.png", width=480, height=480)
dev.off()