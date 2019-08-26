## packages
pacman::p_load(tidyverse, rmarkdown, knitr, tidyr, googledrive)

pacman::p_load(blogdown)

## blogdown

## Packages
## options(repos=structure(c(CRAN="http://ftp.acc.umu.se/mirror/CRAN/"))) ## set dafault repo
## install.packages("blogdown")
## blogdown::install_hugo()
## blogdown::update_hugo()
## install.packages('later')
## install.packages('plotrix')

## Step 1: Make an empty repo on github

wd <- getwd()

## Step 2: Clone empty repo to pc
##setwd("/home/eee/e/blog") # Start R in the new empty folder
setwd("/home/e/ols")

## Step 3: Create site
## blogdown::new_site(theme = "MunifTanjim/minimo") ## Minimo

## Step 4: Edit site content
## Note: Change things in static, content but not in public folder (the latter will be created/updated automatically) 
## Note: Cannot push to github from work due to firewall?

## Step 4: Serve Site
getwd()
blogdown::serve_site()
getwd()

setwd(wd)

## Step 5: Commit all changes

## Step 6: Push to github

## Ikoner
## För webbflik: Lägg favicon.ico (32x32px) i /themes/minimo/static. Där ligger även en kopia som heter "favicon-32x32.png", oklart vad den gör
## Var ligger hemikonen??



## render
## render("politikerdebatt-fragor-grupperade.rmd", "word_document", encoding="UTF-8")

## 177 anmälda
## Laktos 3
## Gluten 6
## Vegan 2

## 17.15 Foajen wilandersalen, dukas upp.

## Surdegsfrall amed veganröra
## 27 + 19  + moms = 51.50
## carina.kjellstrom@regionorebrolan.se
## 9115.5
## Dela upp fakturan på två

## Praliner 10 kr/st
## 1770 kr

## Lokal 1000 kr

## (1000 + 1770)/2 + 9115.5/2

##  9115.5 - 5942
## Summa 10885.5 kr

## Notes ----------------------------------

## Note: Add .gitignore
## Add .gitignore with below content to include all files
## !*
## *.*~

## Note gitignore .md and .html, png etc
## Note: Use git add --force *
## Note: Use recent HUGO version on netlify deploy settings

## add to config.toml
## [[menu.main]]
## name = "Test"
## weight = -10
## identifier = "Testing"
## url = "https://bookdown.org/yihui/blogdown/workflow.html"

## 2. Perhaps you want to add some content. You can add single files
##    with "hugo new <SECTIONNAME>\<FILENAME>.<FORMAT>".
## 3. Start the built-in live server via "hugo server".

## Visit https://gohugo.io/ for quickstart guide and full documentation.
## trying URL 'https://github.com/yihui/hugo-lithium-theme/archive/master.zip'
## Content length 119078 bytes (116 KB)
## downloaded 116 KB

