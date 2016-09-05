# TO GENERATE THE REQUIRED PNGS, SIMPLY SOURCE THIS FILE. 

# setwd upon script source
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

# Load libraries
library(dplyr)
library(lubridate)


# get data
input_dirname <- "./input"
if (!file.exists(input_dirname)){
  dir.create(input_dirname)
}

# create output dir
output_dirname <- "." # remove subfolder for this assignment
if (!file.exists(output_dirname)){
  dir.create(output_dirname)
}

# source URL of the data
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# download and unzip the data
temp <- tempfile(tmpdir = input_dirname, fileext = ".zip")
download.file(url, temp)
unzip(temp, exdir = input_dirname)
unlink(temp)

# get file path(s) for data files
input_file_paths = list.files(input_dirname, full.names = T, recursive = T)

# read data into R for each file
for (i in 1:length(input_file_paths)) {
  key <- paste("data", i, sep="_")
  assign(key, tbl_df(read.table(input_file_paths[i], header = T, sep=";", na.strings = "?", stringsAsFactors = F))) # adjust these params as needed
}

# subset only obs from 2/1/2007 and 2/2/2007

plot_data <- data_1 %>%
  filter(Date == "1/2/2007" | Date == "2/2/2007")

# create POSIXct variable from Date and Time

plot_data$Time_Stamp <- dmy_hms(as.character(paste(plot_data$Date, plot_data$Time)))

# open default graphics device

if(dev.cur() == 1) dev.new()

#create output path
plot3_filename <- file.path(output_dirname, "plot3.png") 

# graph the data & save to file

dev.copy(png, plot3_filename, width=480, height=480)
plot(plot_data$Time_Stamp, plot_data$Sub_metering_1, main=NA, type="l", xlab = NA, ylab = "Energy sub metering", lheight = 1.25)
lines(plot_data$Time_Stamp, plot_data$Sub_metering_2, col="red")
lines(plot_data$Time_Stamp, plot_data$Sub_metering_3, col="blue")
legend("topright", legend = c(names(select(plot_data, 7:9))), lty=c(1,1), col=c("black", "red", "blue"))
dev.off()

