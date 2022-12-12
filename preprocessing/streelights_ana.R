############# Streetlights  ##############

stLight <- read.csv("data/Street_Lights.csv")
#modify lumens column to get numerical value
stLight$Lumens <- as.numeric(gsub(",", "", str_extract_all(stLight$Lumens,"\\(?[0-9,.]+\\)?")))
#convert null values to zero
stLight$Lumens[is.na(stLight$Lumens)] <- 0
#######################################