scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

total <- tapply(pm25$Emissions, pm25$year, sum, na.rm=TRUE)
color <- rgb(0,0,1, alpha=0.3)
barplot(total, col=color, xlab="Year", ylab="PM25 Emission (ton)", 
        border="red", main="Total PM25 Emission" )

pm25_baltimore <- subset(pm25, pm25$fips == "24510")
pm25_bal_total <- tapply(pm25_baltimore$Emissions, pm25_baltimore$year, sum, na.rm=TRUE)
color <- rgb(0,0,1, alpha=0.3)
barplot(pm25_bal_total, col=color, xlab="Year", ylab="Total PM25 Emission (ton)", 
        border="red", main="Total PM25 Emission in Baltimore")

library(dplyr)

pm25_bal_sum <- pm25_baltimore %>% group_by(type, year) %>% summarise(sum_emission=sum(Emissions))
pm25_bal_sum$year <- factor(pm25_bal_sum$year)
pm25_bal_sum$type <- factor(pm25_bal_sum$type)

library(ggplot2)
g <- ggplot(pm25_bal_sum, aes(year, sum_emission))
g + geom_bar(stat="identity") + facet_grid(.~type)

scc$all_text <- paste(scc$Short.Name, scc$SCC.Level.One, scc$SCC.Level.Two, 
            scc$SCC.Level.Three, scc$SCC.Level.Four, 
            scc$EI.Sector, sep=" ")

scc.comb.coal.lg<- grepl("combustion", scc$all_text, ignore.case = TRUE) &
                grepl("coal", scc$all_text, ignore.case = TRUE)
pm25.com.coal <- subset(pm25, pm25$SCC %in% scc[scc.comb.coal.lg,]$SCC)

