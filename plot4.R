# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# subset only SCC text has "coal" and "comb" - case insensitive
pm25.comb.coal <- subset(pm25, pm25$SCC %in% scc[scc.comb.coal.lg,]$SCC)
pm25.comb.coal.yearly <- tapply(pm25$Emissions,pm25$year, sum, na.rm=TRUE)
barplot(pm25.comb.coal.yearly)