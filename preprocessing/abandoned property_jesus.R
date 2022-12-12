lots <- st_read('data/Abandoned_Property_Parcels/Abandoned_Property_Parcels.shp') %>% arrange(desc(Zip_Code))
lots <- (st_transform(st_as_sf(lots), 4326))
lots$Structures <- str_extract(lots$Structures,"(\\w+)")
#lot types were reduced to three different categories: Commercial, Residential, NA
lots <- lots %>% mutate(Structures = recode(Structures,
                                            "Commercial Building" = "Commercial",
                                            "Buildings" = "Commercial",
                                            "Industrial" = "Commercial",
                                            "Mixed" = "Commercial",
                                            "Community" = "Commercial",
                                            "House" = "Residential",
                                            "Houses" = "Residential",
                                            "Mutli" = "Residential",
                                            "Multi" = "Residential",
                                            "Duplex" = "Residential",
                                            "HOUSE" = "Residential"
))
#preprocessing of licenses data set
zips = c(46637, 46635, 46628, 46625, 46623, 46619, 46618, 46617, 46616, 46615, 46614, 46613, 46601)
categories = c("Active","Inactive","Voided","Renewal Notice","In Review")
licenses <- read.csv("data/Business_Licenses_geocoded.csv")
#Extracted 5 digit zip code and filtered to include only those found in vacant lots data set (zips variable)
licenses$Zip_Code <- as.character(licenses$Zip_Code)
licenses$Zip_Code <- substring(licenses$Zip_Code, first = 0,last =5)
licenses$Zip_Code <- as.integer(licenses$Zip_Code)
licenses2 <- licenses %>% 
  st_as_sf(coords = c("X","Y")) %>% 
  st_set_crs(value = 4326) %>% 
  filter(Zip_Code %in% zips) %>% 
  #license status was reduced to 5 broad categories (categories variable)
  mutate(License__1= recode(License__1, 
                            '1st Renewal Notice' = "Renewal Notice", 
                            '2nd Renewal Notice' = "Renewal Notice", 
                            '3rd Renewal Notice' = "Renewal Notice", 
                            '4th Renewal Notice' = "Renewal Notice",
                            'Active and Licensed' = 'Active',
                            'Renewed' = 'Active',
                            'Incative and no longer licensed' = 'Inactive',
                            'Out of Business' = 'Inactive',
                            'Payment Pending' = 'In Review')) %>% 
  filter(License__1 %in% categories)