## Hantera anmälningar via google
pacman::p_load(tidyverse, rmarkdown, knitr, tidyr, googledrive, xlsx)

wd <- getwd()
wd_dropbox <- "/home/eee/Dropbox/Örebro läkaresällskap/"

## get from google drive
## drive_find(n_max = 50)
## s <- drive_find(pattern = "Anmälan", n_max = 50)
## s$name[1]
## drive_download("Anmälan till Sjukvårdsdebatt med de politiska partierna (Responses)", type = "csv")
## Note: Swedish cahracters not working (?)
## s <- drive_find(pattern = "anm", n_max = 50)
## s$name[1]
## drive_download(s$name[1], type = "csv")

## read downloaded csv
anm_sjvdb <- read_csv("anm_sjvdb.csv")
names(anm_sjvdb) <- make.names(names(anm_sjvdb))
## remove duplicates (removes all except last)
anm_sjvdb%>%
    arrange(Email.address) -> anm_sjvdb
anm_sjvdb <- anm_sjvdb[
    !duplicated(anm_sjvdb["Email.address"]),
] 

### make email list
add_email <- c("ulrica.thunberg@regionorebrolan.se")
#### corrections
email_list <- c(anm_sjvdb["Email.address"][[1]], add_email)
email_list <- gsub("ggunnar", "gunnar", email_list)
email_list <- gsub("maud_carpenter@hotmail.co", "maud_carpenter@hotmail.com", email_list)
### write email list to dropbox
setwd(wd_dropbox)

write_lines(
    paste(anm_sjvdb$Email.address, ",", sep = "")
  , path = paste(wd_dropbox, "anm_sjukvardsdebatt_epostlista.txt", sep=""))

setwd(wd)

## print anmalda
unique(anm_sjvdb["Email.address"][[1]]) ## unika anmälda
length(unique(anm_sjvdb["Email.address"][[1]])) ## antal anmälda
sum(anm_sjvdb[["Önskar.du.fralla...dryck.före.debatten."]] == "JA tack") ## antal frallor
anm_sjvdb[["Kostrestriktioner..standardfrallan.är.vegetarisk."]][!is.na(anm_sjvdb[["Kostrestriktioner..standardfrallan.är.vegetarisk."]])]

## 159 unika anmälningar, varav 142 önskar fralla.
## Glutenfritt 3 st
## Gluten- och laktosfritt 1 st
## Laktosfritt 2 st
## Vegan 2 st

## Sena anmälningar som tillkommer:
## ulrica.thunberg@regionorebrolan.se

## Avanmälningar
## Maja Wästfelt (Kvittas mot Ulrica ovan)

## uppdatera medlemsregister
setwd(wd_dropbox)
## medlemmar <- read.xlsx("ols_medlemsregister.xlsx",
##           sheetIndex = 2)

## medlemmar_old <- cbind(
##     as.character(medlemmar$Namn[!is.na(medlemmar$Epost)]),
##     as.character(medlemmar$Epost[!is.na(medlemmar$Epost)])
## )

str(anm_sjvdb)
str(medlemmar)

medlemmar <- read.xlsx("ols_medlemsregister2018.xlsx",
           sheetIndex = 1)

medlemmar_new <- anm_sjvdb[c("Namn", "Email.address")]
medlemmar_old <- data.frame(medlemmar_old)
names(medlemmar_old) <- names(medlemmar_new)

medlemmar <- rbind(medlemmar_new,
      medlemmar_old
      )
medlemmar <- medlemmar[!duplicated(medlemmar$Email.address),] ## remove duplicated, keeping the latest email address

medlemmar%>%
    arrange(Namn) -> medlemmar

### write new reg
write.xlsx(medlemmar, "medlemsregister2018.xlsx")

### write new wmail list
## sink("ols_epostlista2018.txt")
##     paste(medlemmar$Email.address,
##           collapse = ", ")
## sink()

write_lines(
    paste(medlemmar$Email.address, ",", sep = "")
  , path = paste(wd_dropbox, "epostlista2018.txt", sep=""))

list.files()
