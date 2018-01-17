options(repos = "https://cran.r-project.org")
Sys.setenv(TZ='America/Los_Angeles')
# Installing packages ------------------------------------------------------------------

if (!require('jsonlite')) install.packages('jsonlite')
if (!require('devtools')) install.packages('devtools')
if (!require('stringr')) install.packages('stringr')
if (!require('urlshorteneR')) install.packages('urlshorteneR')
if (!require('rvest')) install.packages('rvest')

install_github("geoffjentry/twitteR")

library('rjson')
library('twitteR')
library('devtools')
library('urlshorteneR')
#library('rvest')

First.record <- 1
Last.record <- 2294

i = sample(First.record:Last.record, 1)

image.url <- paste0('http://digitalcollections.lib.washington.edu/utils/ajaxhelper/?CISOROOT=loc&CISOPTR=',i,'&action=2&DMSCALE=70&DMWIDTH=512&DMHEIGHT=466&DMX=0&DMY=0&DMTEXT=&DMROTATE=0')
page.url  <- paste0('http://digitalcollections.lib.washington.edu/cdm/singleitem/collection/loc/id/',i)
download.file(image.url, 'tmp.jpg', mode = 'wb')
short.url <- isgd_LinksShorten(longUrl = page.url)

webpage <- read_html(page.url)

data<-
webpage %>%
  html_text('image_title') %>%
 .[[1]] #%>%
  #html_table()

data <- substring(data, 1, 116)
data <-gsub("::.*","",data)


tweet.text <- paste0(data, short.url)


# set up twitter api
credentials.file = "credentials.json"


credentials <- fromJSON(file=credentials.file)
ckey <- credentials$twitter$consumer_key
csecret <- credentials$twitter$consumer_secret
atoken <- credentials$twitter$access_token
asecret <- credentials$twitter$access_secret

#options(httr_oauth_cache=T)
setup_twitter_oauth(ckey, csecret, atoken, asecret)

tweet(tweet.text, media = "tmp.jpg")

