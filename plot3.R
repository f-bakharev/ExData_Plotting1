# Plot 3: Energy sub-metering over Time

# Download and prepare data if it doesn't exist
if (!file.exists("household_power_consumption.txt")) {
    # Create a temporary file
    temp <- tempfile()
    
    # Download the zip file
    download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip",
                  temp)
    
    # Unzip the file
    unzip(temp, "household_power_consumption.txt")
    
    # Remove the temporary file
    unlink(temp)
}

# Read and prepare the data
prepare_power_data <- function() {
    # Read the data
    power_data <- read.table("household_power_consumption.txt", 
                            header = TRUE, 
                            sep = ";", 
                            na.strings = "?",
                            colClasses = c("character", "character", rep("numeric", 7)))
    
    # Combine Date and Time columns and convert to POSIXct
    power_data$DateTime <- as.POSIXct(paste(power_data$Date, power_data$Time), 
                                     format = "%d/%m/%Y %H:%M:%S")
    
    # Subset data for February 1-2, 2007
    subset_data <- subset(power_data, 
                         DateTime >= as.POSIXct("2007-02-01") & 
                         DateTime < as.POSIXct("2007-02-03"))
    
    return(subset_data)
}

# Create Plot 3
plot3 <- function() {
    # Get the data
    data <- prepare_power_data()
    
    # Open PNG device
    png(filename = "plot3.png", 
        width = 480, 
        height = 480, 
        units = "px")
    
    # Create time series plot with first sub-metering
    plot(data$DateTime, data$Sub_metering_1,
         type = "l",
         ylab = "Energy sub metering",
         xlab = "")
    
    # Add other sub-meterings
    lines(data$DateTime, data$Sub_metering_2, col = "red")
    lines(data$DateTime, data$Sub_metering_3, col = "blue")
    
    # Add legend
    legend("topright", 
           col = c("black", "red", "blue"),
           lty = 1,
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # Close the PNG device
    dev.off()
}

# Generate the plot
plot3() 