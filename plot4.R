# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# create a new column on scc pasting all the text at other columns
# word will be searched in this new column
scc$all_text <- paste(scc$Short.Name, scc$SCC.Level.One, scc$SCC.Level.Two, 
                      scc$SCC.Level.Three, scc$SCC.Level.Four, 
                      scc$EI.Sector, sep=" ")
# create logical vector from scc DF with lows that have "coal" and "combustion" in the text
scc.comb.coal.lg<- grepl("combustion", scc$all_text, ignore.case = TRUE) &
    grepl("coal", scc$all_text, ignore.case = TRUE)

# subset pm25 with the above logical vector 
pm25.comb.coal <- subset(pm25, pm25$SCC %in% scc[scc.comb.coal.lg,]$SCC)

# calculate yearly total
pm25.comb.coal.yearly <- tapply(pm25$Emissions,pm25$year, sum, na.rm=TRUE)

# plot it
color <- rgb(0,0,1, alpha=0.3)
barplot(pm25.comb.coal.yearly, col=color, xlab="Year", ylab="Emission (ton)", 
        border="red", main="Total Emission from Coal Combustion in US" )

# save as png file
dev.copy(png, filename="plot4.png", width=480, height=480)
dev.off()