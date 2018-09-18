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
add_email <- c("ulrica.thunberg@regionorebrolan.se",
               "anneli.pahlson5@regionorebrolan.se",
               "bayar.baban@regionorebrolan.se",
               "g-falck.apoteksgarden@telia.com",
               "eva.melander@regionorebrolan.se",
               "anna.winberg@regionorebrolan.se",
               "lena.wijk@regionorebrolan.se",
               "ulrica.thunberg@regionorebrolan.se",
               "timmisen@gmail.com",
               "faduma.omar@regionorebrolan.se",
               "anna.olivecrona@regionorebrolan.se",
               "viktor.olofsson@regionorebrolan.se",
               "magnus.svensson@regionorebrolan.se",
               "gina.sidiqi@regionorebrolan.se",
               "gabriella.widlund@regionorebrolan.se",
               "teres.litzell@regionorebrolan.se",
               "eric.stenninger@regionorebrolan.se",
               "erik.schwarcz@regionorebrolan.se",
               "john.henriksson@regionorebrolan.se"
               )

## EJ FIKA
ej_fika <- c("erik.schwarcz@regionorebrolan.se",
             "john.henriksson@regionorebrolan.se"
             )

## Avbokat:
avbokat <- c("charlotta.wrenninge@regionorebrolan.se", "emma.wiberg@regionorebrolan.se", "bo.soderquist@regionorebrolan.se", "alden_jenny@hotmail.com", "asa.ludvigsson@regionorebrolan.se")
##, asa ludvigsson,
## 6 extra frallor

#### corrections
anm_sjvdb["Email.address"][[1]] <- gsub("ggunnar", "gunnar", anm_sjvdb["Email.address"][[1]])
anm_sjvdb["Email.address"][[1]] <- gsub("maud_carpenter@hotmail.co", "maud_carpenter@hotmail.com", anm_sjvdb["Email.address"][[1]])

## lista unika epostadresser minus avbokade
anm <- c(
    unique(anm_sjvdb["Email.address"][[1]]),
  add_email) ## unika anmälda (en del kan ha avbokat)
anm <- anm[!(anm %in% avbokat)] ## minus avbokade
anm <- unique(anm) ## remove duplicated

## email list fralla = JA
anm_sjvdb%>%
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
  , path = paste(wd_dropbox, "anm_sjukvardsdebatt_epostlista.txt", sep=""))
write_lines(
    paste(fralla, ",", sep = "")
  , path = paste(wd_dropbox, "anm_sjukvardsdebatt_fralla.txt", sep=""))
write_lines(
    paste(utan_fralla, ",", sep = "")
  , path = paste(wd_dropbox, "anm_sjukvardsdebatt_utan_fralla.txt", sep=""))

## print anmalda
anm
length(anm) ## antal anmälda
length(fralla)
length(add_email)
length(avbokat)
anm_sjvdb[["Kostrestriktioner..standardfrallan.är.vegetarisk."]][!is.na(anm_sjvdb[["Kostrestriktioner..standardfrallan.är.vegetarisk."]])]

names(anm_sjvdb)

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
