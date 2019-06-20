## Hantera anmälningar via google
pacman::p_load(tidyverse, rmarkdown, knitr, tidyr, googledrive)
library(readxl)

## xlsx not working weel dye to java right now

##require(xlsx)

wda <- getwd()
wd_dropbox <- "/home/e/Dropbox/Örebro läkaresällskap/"

## antal medlemmar i nuvarande epostlista
## setwd(wd_dropbox)
## list.files()
## temp <- readLines("epostlista2018.txt")
## length(temp)
## temp <- sapply(temp, function(x) strsplit(x, "@")[[1]][1])
## names(temp) <- NULL
## length(unique(tolower(temp)))

## Also an alternative method is to export LD_LIBRARY_PATH with the value of Java library path obtained from the command R CMD javareconf -e
## .libPaths()
## libjvm.so
## export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server/libjvm.so


## get from google drive
drive_find(n_max = 50)
## s <- drive_find(pattern = "anm", n_max = 50)
## s$name[1]
## drive_download(s$name[1], type = "csv")
## Note: Swedish cahracters not working (?)
## s <- drive_find(pattern = "anm", n_max = 50)
## s$name[1]
## drive_download(s$name[1], type = "csv")

nm <- "anm_leonardo2019" ## enter name

drive_download(nm, type = "csv")

## read downloaded csv
anmalan <- read_csv("anm_leonardo2019.csv")
names(anmalan) <- make.names(names(anmalan))
## remove duplicates (removes all except last)

anmalan%>%
    arrange(Email.Address) -> anmalan
anmalan <- anmalan[
    !duplicated(anmalan["Email.Address"]),
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
    unique(anmalan["Email.Address"][[1]]),
  add_email) ## unika anmälda (en del kan ha avbokat)
anm <- anm[!(anm %in% avbokat)] ## minus avbokade
anm <- unique(anm) ## remove duplicated

## email list fralla = JA
names(anmalan)

anmalan%>%
    filter(Önskar.du.tilltugg...dryck.. == "JA tack") -> temp
fralla <-  c(temp$Email.Address, add_email)
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
  , path = paste(wd_dropbox, nm, ".txt", sep=""))
write_lines(
    paste(fralla, ",", sep = "")
  , path = paste(wd_dropbox, "anm_fralla.txt", sep=""))
write_lines(
    paste(utan_fralla, ",", sep = "")
  , path = paste(wd_dropbox, nm, ".txt", sep=""))

## print anmalda
anm
length(anm) ## antal anmälda
length(fralla)
length(add_email)
length(avbokat)
anmalan[["Kostrestriktioner"]][!is.na(anmalan[["Kostrestriktioner"]])]

## uppdatera medlemsregister
setwd(wd_dropbox)
## medlemmar <- read.xlsx("ols_medlemsregister.xlsx",
##           sheetIndex = 2)

## medlemmar <- read_excel('medlemsregister2019.xlsx')
medlemmar <- read_delim('medlemsregister2019.txt',
                        delim = ";",
                        col_names = FALSE)[, 1:2]

medlemmar[[1]] <- trimws(medlemmar[[1]])
medlemmar[[2]] <- trimws(medlemmar[[2]])

## medlemmar_old <- cbind(
##     as.character(medlemmar$Namn[!is.na(medlemmar$Email.address)]),
##     as.character(medlemmar$Email.address[!is.na(medlemmar$Email.address)])
## )
## str(anmalan)
## str(medlemmar)
## medlemmar <- read.xlsx("ols_medlemsregister2018.xlsx",
##            sheetIndex = 1)

medlemmar_new <- anmalan[c("Namn", "Email.Address")]
medlemmar_old <- medlemmar
    ##data.frame(medlemmar_old)
names(medlemmar_old) <- names(medlemmar_new)

medlemmar <- rbind(medlemmar_new,
      medlemmar_old
      )
medlemmar <- medlemmar[!duplicated(medlemmar$Email.Address),] ## remove duplicated, keeping the latest email Address

medlemmar%>%
    arrange(Namn) -> medlemmar

medlemmar <- medlemmar[!duplicated(tolower(medlemmar$Email.Address)),] ## remove duplicated emails

## remove duplicated from register
medlemmar_unique <- medlemmar[!duplicated(tolower(medlemmar$Namn)),]
medlemmar_unique <- medlemmar_unique[!duplicated(tolower(medlemmar_unique$Email.Address)),]

medlemmar <- medlemmar_unique

## write
write_lines(
    paste(medlemmar$Namn, ";", medlemmar$Email.Address, ";")
  , path = paste(wd_dropbox, "medlemsregister-", Sys.Date(), ".txt", sep=""))

write_lines( ## update
    paste(medlemmar$Namn, ";", medlemmar$Email.Address, ";")
  , path = paste(wd_dropbox, "medlemsregister", format(Sys.Date(), "%Y"), ".txt", sep=""))

write_lines( ## update
    paste(medlemmar$Namn, ";", medlemmar$Email.Address, ";")
  , path = paste(wd_dropbox, "medlemsregister", format(Sys.Date(), "%Y"), ".csv", sep=""))

write_lines( ## archive
    paste(medlemmar_old$Namn, ";", medlemmar_old$Email.Address, ";")
  , path = paste(paste0(wd_dropbox, "arkiv/"), "medlemsregister-backup-", Sys.Date(), ".txt", sep=""))

write_lines( ## update
    paste(medlemmar$Namn, ";", medlemmar$Email.Address, ";")
  , path = paste("medlemsregister", format(Sys.Date(), "%Y"), ".csv", sep=""))

write_lines(
    paste(medlemmar$Email.Address, ";")
  , path = paste(wd_dropbox, "medlemmar-epost-", Sys.Date(), ".txt", sep=""))


### write new reg

### write new wmail list
## sink("ols_epostlista2018.txt")
##     paste(medlemmar$Email.address,
##           collapse = ", ")
## sink()

nrow(medlemmar_old)
nrow(medlemmar_new)
nrow(medlemmar_unique) ## 269
nrow(medlemmar)

