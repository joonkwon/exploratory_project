# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# subset only baltimore data
pm25_baltimore <- subset(pm25, pm25$fips == "24510")
# calculate yearly total for baltimore data
pm25_bal_total <- tapply(pm25_baltimore$Emissions, pm25_baltimore$year, sum, na.rm=TRUE)

library(dplyr)

# calculate sum by type and year groups
pm25_bal_sum <- pm25_baltimore %>% group_by(type, year) %>% summarise(sum_emission=sum(Emissions))
pm25_bal_sum$year <- factor(pm25_bal_sum$year)
pm25_bal_sum$type <- factor(pm25_bal_sum$type)

# plot it into multi facets graph.
library(ggplot2)
g <- ggplot(pm25_bal_sum, aes(year, sum_emission))
g + geom_bar(stat="identity") + facet_grid(.~type) + 
    labs(title="PM2.5 Emissions by Type in Baltimore City", y="PM2.5 Emission (ton)")

dev.copy(png, "plot3.png", width=600, height=480)
dev.off()