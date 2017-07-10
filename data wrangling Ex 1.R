#load my packages
library(devtools)
library(dplyr)
library(tidyr)
library(readr)
#load file
purchases <- refine_original
#company column cleaning : correct spelling and make them lower case
purchases$company <- tolower (purchases$company)
purchases$company <- sub(pattern = ".*\\ps$" , replacement = "philips", x = purchases$company)
purchases$company <- sub(pattern = "^ak.*" , replacement = "akzo", x = purchases$company)
purchases$company <- sub(pattern = "^u.*" , replacement = "unilever", x = purchases$company)
purchases$company <- sub(pattern = "^v.*" , replacement = "van houten", x = purchases$company)
# separate the product code and number and make them 2 columns
purchases <- separate (purchases, "Product code / number", c("product_code", "product_number"), sep = "-")
# add product category by adding a new column
purchases$product_category <- sub(pattern = "^p$", replacement = "Smartphone", x = sub("^x$", "Laptop", sub("^v$", "TV", sub("^q$", "Tablet", purchases$product_code))))
# Add a column with the full address separated by commas
purchases <- purchases %>% 
  mutate(full_address = paste(address, city, country, sep = ","))
#Create dummy variables for company and product category
purchases <- mutate(purchases, company_philips = ifelse(company == "philips", 1, 0))
purchases <- mutate(purchases, company_akzo = ifelse(company == "akzo", 1, 0))
purchases <- mutate(purchases, company_van_houten = ifelse(company == "van houten", 1, 0))
purchases <- mutate(purchases, company_unilever = ifelse(company == "unilever", 1, 0))
purchases <- mutate(purchases, product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
purchases <- mutate(purchases, product_tv = ifelse(product_category == "TV", 1, 0))
purchases <- mutate(purchases, product_laptop = ifelse(product_category == "Laptop", 1, 0))
purchases <- mutate(purchases, product_tablet = ifelse(product_category == "Tablet", 1, 0))
# output to csv
write.csv(purchases, "refine_clean.csv")
View(purchases)

