## Hantera anmälningar via google
pacman::p_load(tidyverse, rmarkdown, knitr, tidyr, googledrive, xlsx)
require(xlsx)
wd <- getwd()
wd_dropbox <- "/home/eee/Dropbox/Örebro läkaresällskap/"

## Also an alternative method is to export LD_LIBRARY_PATH with the value of Java library path obtained from the command R CMD javareconf -e
## .libPaths()
## libjvm.so
## export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server/libjvm.so


## get from google drive
drive_find(n_max = 50)
s <- drive_find(pattern = "anm", n_max = 50)
s$name[1]
drive_download(s$name[1], type = "csv")
## Note: Swedish cahracters not working (?)
## s <- drive_find(pattern = "anm", n_max = 50)
## s$name[1]
## drive_download(s$name[1], type = "csv")

## read downloaded csv
anmalan <- read_csv("anm_dodshjalpsdebatt.csv")
names(anmalan) <- make.names(names(anmalan))
## remove duplicates (removes all except last)
anmalan%>%
    arrange(Email.address) -> anmalan
anmalan <- anmalan[
    !duplicated(anmalan["Email.address"]),
] 

### make email list
add_email <- c()

## EJ FIKA
ej_fika <- c()

## Avbokat:
avbokat <- c()

#### corrections
## anmalan["Email.address"][[1]] <- gsub("ggunnar", "gunnar", anmalan["Email.address"][[1]])
## anmalan["Email.address"][[1]] <- gsub("maud_carpenter@hotmail.co", "maud_carpenter@hotmail.com", anmalan["Email.address"][[1]])

## lista unika epostadresser minus avbokade
anm <- c(
    unique(anmalan["Email.address"][[1]]),
  add_email) ## unika anmälda (en del kan ha avbokat)
anm <- anm[!(anm %in% avbokat)] ## minus avbokade
anm <- unique(anm) ## remove duplicated

## email list fralla = JA
anmalan%>%
    filter(Önskar.du.fralla...dryck.före.debatten. == "JA tack") -> temp
fralla <-  c(temp$Email.address, add_email)
fralla <- fralla[fralla %in% anm] ## minus avbokade
fralla <- fralla[!duplicated(fralla)]
fralla <- fralla[!(fralla %in% ej_fika)] ## minu ej fika
utan_fralla <- anm[!(anm %in% fralla)]

## check
c(fralla, utan_fralla) %in% anm
length(fralla) + length(utan_fralla) ==
    length(anm)

## write email lists
setwd(wd_dropbox)
write_lines(
    paste(anm, ",", sep = "")
  , path = paste(wd_dropbox, "anm_dodshjalpsdebatt_epostlista.txt", sep=""))
write_lines(
    paste(fralla, ",", sep = "")
  , path = paste(wd_dropbox, "anm_dodshjalpsdebatt_fralla.txt", sep=""))
write_lines(
    paste(utan_fralla, ",", sep = "")
  , path = paste(wd_dropbox, "anm_dodshjalpsdebatt_utan_fralla.txt", sep=""))

## print anmalda
anm
length(anm) ## antal anmälda
length(fralla)
length(add_email)
length(avbokat)
anmalan[["Kostrestriktioner..standardfrallan.är.vegetarisk."]][!is.na(anmalan[["Kostrestriktioner..standardfrallan.är.vegetarisk."]])]

names(anmalan)

## 159 unika anmälningar, varav 153 önskar fralla.
## Glutenfritt 3 st
## Gluten- och laktosfritt 1 st
## Laktosfritt 2 st
## Vegan 2 st

## uppdatera medlemsregister
setwd(wd_dropbox)
## medlemmar <- read.xlsx("ols_medlemsregister.xlsx",
##           sheetIndex = 2)

## medlemmar_old <- cbind(
##     as.character(medlemmar$Namn[!is.na(medlemmar$Epost)]),
##     as.character(medlemmar$Epost[!is.na(medlemmar$Epost)])
## )

str(anmalan)
str(medlemmar)

medlemmar <- read.xlsx("ols_medlemsregister2018.xlsx",
           sheetIndex = 1)

medlemmar_new <- anmalan[c("Namn", "Email.address")]
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
