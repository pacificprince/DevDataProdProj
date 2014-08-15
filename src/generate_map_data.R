#' generate_map__data
#' 
#' Program to read Academic Performance Index (API) data for schools in 
#' California, filter desired columns, summarize APIs by county, merge county
#' with lat,long information and save processed data to 'rds' file
#' For further information about the data see the original website
#' http://www.cde.ca.gov/ta/ac/ap/apidatafiles.asp.
#' 
#' @author Prashanth Kumar <pacificprince@gmail.com>
#' @param  file.url URL of zip file to download
#' @param  outfile  `rds` filename to which processed data is saved
#' @export
#' @examples
#' generate_map_data("http://www3.cde.ca.gov/researchfiles/api/14avgdb.zip", 
#'                 "avg_api.rds", )
#'                 

file.url <- "http://www3.cde.ca.gov/researchfiles/api/14avgdb.zip"
outfile  <- "data/cal3yr_avg_api_map_data.rds"

library(reshape2)
library(maps)
library(plyr)

generate_map_data <- function(file.url, outfile){
  # Get zip filename from URL
  filename <- file.path("data", basename(file.url))
  
  # If file does not already exist then download and unzip file
  if(!file.exists(filename)){
    download.file(file.url, destfile = filename)
    download.date <- date() # Date stamp the downloaded data
  }
  unzip(filename, "14avgdb.dbf", exdir="data")
  
  # Read dbf file into dataframe
  library(foreign)
  data <- read.dbf("data/14avgdb.dbf", as.is = TRUE)
  
  # Filter columns and replace "NA" in charter column with "N" as per codebook
  # and convert all API columns to numeric
  data <- data[, c(1, 3, 6, 7:9, seq(from=18, to=106, by=8))]
  data[, 7:NCOL(data)] <- sapply(data[, 7:NCOL(data)], FUN = as.numeric)
  data$charter <- with(data, ifelse(is.na(charter), "N", charter))
  
  # Replace column names with more meaningful names
  cnames <- c("CountyDistrictSchoolCode", 
              "SchoolType", 
              "Charter", 
              "SchoolName",
              "DistrictName", 
              "CountyName", 
              "Overall", 
              "AfricanAmerican", 
              "AmericanIndian", 
              "Asian", 
              "Filipino", 
              "Hispanic", 
              "PacificIslander", 
              "White", 
              "MultiRace", 
              "SocioEconDisadvantaged", 
              "EnglishLearners", 
              "StudentDisabilities")
  colnames(data) <- cnames
  
  # Replace SchoolType and Charter columns with expanded entries
  data$SchoolType <- gsub("E", "Elementary", data$SchoolType)
  data$SchoolType <- gsub("H", "High", data$SchoolType)
  data$SchoolType <- gsub("M", "Middle", data$SchoolType)
  
  data$Charter <- gsub("Y", "Yes", data$Charter)
  data$Charter <- gsub("D", "Indirect", data$Charter)
  data$Charter <- gsub("N", "No", data$Charter)
    
  # Replace all "NA"s with 0
  data[is.na(data)] <- 0
  
  nc <- NCOL(data)
  data <- melt(data, id.vars = colnames(data)[1:6], 
               measure.vars = colnames(data)[7:nc])
  colnames(data) <- c(colnames(data)[1:6], "Group", "AvgAPI")
  data$Group  <- sapply(data$Group, as.character)
  data$AvgAPI <- sapply(data$AvgAPI, as.numeric)  
  
  data <- ddply(subset(data, Group == "Overall"), 
                .(SchoolType, CountyName), summarize, mean(AvgAPI))
  colnames(data) <- c("school_type", "subregion", "avg_api")
  data$subregion <- tolower(data$subregion)
  
  data$school_type <- 
    factor(data$school_type, levels = c("Elementary", "Middle", "High"))
  
  county_map <- map_data("county")
  county_map <- subset(county_map, region == "california")
  county_map$region <- NULL
  
  data <- merge(data, county_map, by = "subregion")  
  
  saveRDS(data, outfile) # Save to RDS file
}

generate_map_data(file.url, outfile)


