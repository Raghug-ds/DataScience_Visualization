

############# Abandoned Properties ##############
abandoned.spatial<-st_read("data/Abandoned_Property_Parcels/Abandoned_Property_Parcels.shp", stringsAsFactors = FALSE) 
abandoned.spatial<-st_cast(abandoned.spatial, "POLYGON") %>%  st_cast(., "POINT") %>% distinct(OBJECTID, .keep_all = TRUE) 
abandoned.spatial <- (st_transform(st_as_sf(abandoned.spatial), 4326))
abandoned_join <- st_join(abandoned.spatial,districts.spatial,join = st_nearest_feature, left = T)
abandoned.spatial$District <- abandoned_join$District
#names(abandoned.spatial)[1] <- "Type"
abandoned.spatial<-abandoned.spatial %>% unite("Property Address",Address_Nu,Street_Nam, Suffix,sep = " ")
abandoned.spatial$popup <- paste("<b>",abandoned.spatial$`Property Address`,"</b><br>",
                                 abandoned.spatial$Structures,"<br>",
                                 abandoned.spatial$Outcome_St)
abandoned_table <- abandoned.spatial %>% select(District,`Property Address`,Structures,Status=Outcome_St)
abandoned_table$geometry<-NULL

#######################################

############# Parks ##############
parks.points <- read.csv("data/Parks_Locations_and_Features.csv")
parks.spatial<- parks.points%>%
  st_as_sf(coords = c("Lon","Lat")) %>% 
  st_set_crs(value = 4326)
parks.join<-st_join(parks.spatial,districts.spatial,join = st_nearest_feature, left = T)
parks.spatial$District <- parks.join$District
parks.spatial$popup <- paste("<b>",parks.spatial$Park_Name,"</b><br>",
                                   parks.spatial$Park_Type,"<br>",
                                   "Address: ",parks.spatial$Address,sep ="")
parks_table <- parks.spatial %>% select(District,"Park Name" = Park_Name, 
                                        "Park Type" = Park_Type, Address)
parks_table$geometry<-NULL
ParkColorType <- colorFactor(palette = 'Set2', domain =parks.spatial$Park_Type)(parks.spatial$Park_Type)
#######################################


############# Facilities ##############
facilities.points <- read.csv("data/Public_Facilities.csv")
facilities.spatial <- facilities.points %>% #projecting the table as an sf and setting the coordinate system
  st_as_sf(coords = c("Lon","Lat")) %>% 
  st_set_crs(value = 4326)
facilities_join <- st_join(facilities.spatial,districts.spatial,join = st_nearest_feature, left = T)
facilities.spatial$District <- facilities_join$District
names(facilities.spatial)[2] <- "Type"
facilities.spatial$POPL_ADDR1<-str_split(facilities.spatial$POPL_ADDR1, "\\n", simplify = T)[,1]
facilities.spatial$popup <- paste("<b>",facilities.spatial$POPL_NAME,"</b><br>",
                                  facilities.spatial$Type,"<br>",
                                 "Address: ",facilities.spatial$POPL_ADDR1,sep ="")
facilities_table <- facilities.spatial %>% select(District,"Facility Name" = POPL_NAME, 
                                                  "Facility Type" = Type,
                                                  Address = POPL_ADDR1, Phone = POPL_PHONE)
facilities_table$geometry<-NULL
#######################################