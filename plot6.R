# load data
scc <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# subset only baltimore data
pm25_baltimore <- subset(pm25, pm25$fips == "24510")

# create a new column on scc pasting all the text at other columns
# word will be searched in this new column
scc$all_text <- paste(scc$Short.Name, scc$SCC.Level.One, scc$SCC.Level.Two, 
                      scc$SCC.Level.Three, scc$SCC.Level.Four, 
                      scc$EI.Sector, sep=" ")

# create a logical vector that show lows that have "vehicle" or "vessel" in the text
scc.vehicle.lg <- (grepl("vehicle", scc$all_text, ignore.case = TRUE) 
                   | grepl("vessel", scc$all_text, ignore.case = TRUE))

# subset only vehicle rows from baltimore data
pm25_bal_veh <- subset(pm25_baltimore, pm25_baltimore$SCC %in% scc[scc.vehicle.lg,]$SCC )

# calculate yearly total
pm25_bal_veh_tot <- tapply(pm25_bal_veh$Emissions, pm25_bal_veh$year, sum, na.rm=TRUE)

# subset only vehicles rows in LA county
pm25_la_veh <- subset(pm25, pm25$fips == "06037" & pm25$SCC %in%  scc[scc.vehicle.lg,]$SCC)
# calculate yearly total
pm25_la_veh_tot <- tapply(pm25_la_veh$Emissions, pm25_la_veh$year, sum, na.rm=TRUE)


# plot it
par(mfrow=c(1,2), mar=c(4,5,2,2), oma=c(0,0,3,0))
color <- rgb(0,0,1, alpha=0.3)
barplot(pm25_bal_veh_tot, col=color, xlab="Baltimore", ylab="PM25 Emission (ton)", 
        border="red")
model <- 
barplot(pm25_la_veh_tot, col=color, xlab="LA",  
        border="red")

mtext("Yearly PM25 Emission from Vehicle", cex=1.5, outer=TRUE)

# save as png file
dev.copy(png, filename="plot6.png", width=600, height=480)
dev.off()