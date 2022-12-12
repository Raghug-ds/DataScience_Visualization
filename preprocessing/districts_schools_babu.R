############# Districts ##############
districts.spatial <- st_read("data/City_Council_Districts/City_Council_Districts.shp", stringsAsFactors = FALSE)
names(districts.spatial)[3] <- "District"

#######################################


############# Schools ##############
schools.spatial<-st_read("data/School_Boundaries/School_Boundaries.shp", stringsAsFactors = FALSE) 
schools.spatial<-st_cast(schools.spatial, "MULTIPOLYGON") %>%  st_cast(., "POINT") %>% distinct(School, .keep_all = TRUE)
schools.spatial <- (st_transform(st_as_sf(schools.spatial), 4326))
schools_join <- st_join(schools.spatial,districts.spatial,join = st_nearest_feature, left = T)
schools.spatial$District <- schools_join$District
#names(schools.spatial)[2] <- "Type"
schools.spatial$popup <- paste("<b>",schools.spatial$School,"</b><br>",
                               schools.spatial$SchoolType,"<br>")
schools_table <- schools.spatial %>% select(District,School, "School Type" = SchoolType)
schools_table$geometry<-NULL

#######################################

############# Census ##############

census.spatial<-st_read("data/2020_CensusData/2020_CensusData.shp", stringsAsFactors = FALSE) 
census.spatial<-st_cast(census.spatial, "POLYGON") %>%  st_cast(., "POINT") %>% distinct(GEOID, .keep_all = TRUE)
census.spatial <- (st_transform(st_as_sf(census.spatial), 4326))
census_join <- st_join(census.spatial,districts.spatial,join = st_nearest_feature, left = T)
census.spatial$District <- census_join$District

census_table <- census.spatial %>%
  drop_na() %>%
  #mutate_all(as.numeric) %>% 
  group_by(District = as.character(District)) %>%
  summarize("Population" = sum(A00001_1))
census_table$geometry<-NULL
#######################################

############# Districts ##############
districts.spatial$population<-census_table$Population
districts.spatial$popup<-paste("District: ",districts.spatial$District,"</b><br>",
                               "Counselor: ",districts.spatial$Council_Me,"<br>",
                               "Population:",districts.spatial$population)
#######################################