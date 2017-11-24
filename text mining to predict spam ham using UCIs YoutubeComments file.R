#text mining to predict spam/ham using UCI's "youtube comments" file
getwd()

#read file
youtube <- read.csv('YoutubeComments.csv', header = T, stringsAsFactors = F)
str(youtube)
summary(youtube)
View(youtube)#note: we just need 'Content' and 'Class', of all variables.
youtube <- youtube[,c(4,5)]
table(youtube$CLASS)
youtube$CLASS <- as.factor(youtube$CLASS)
colnames(youtube) <- c('Content', 'Class') #Didn't like them Bold letters
View(youtube)

#Building corpus
install.packages('tm', dependencies = T)
library(tm)
youtube.corpus <- VCorpus(VectorSource(youtube$Content))
youtube.corpus

#text mining: lowercase,stopwords,punctuations,numbers,whitespaces,stemming
youtube.corpus.lower <- tm_map(youtube.corpus, content_transformer(tolower))
youtube.corpus.stopwords <- tm_map(youtube.corpus.lower,removeWords,stopwords())
youtube.corpus.punctuations <- tm_map(youtube.corpus.stopwords, removePunctuation)
youtube.corpus.numbers <- tm_map(youtube.corpus.punctuations, removeNumbers)
youtube.corpus.whitespaces <- tm_map(youtube.corpus.numbers, stripWhitespace)
youtube.corpus.stemming <- tm_map(youtube.corpus.whitespaces, stemDocument)

youtube.final <- sapply(youtube.corpus.stemming,
                        function(x) iconv(x, "latin1", "ASCII", sub=""))#removes emoji/special characters
#note: this returns a character class, not a corpus class,
#so you'd need a corpus class to form a DocumentTermMatrix.
iconvlist()# this lists the available encodings

#forming a wordcloud
install.packages("wordcloud", dependencies = T)
library(wordcloud)
wordcloud(youtube.final, max.words = 300,
          min.freq = 10, scale = c(2,.5),
          random.order = F, rot.per = .5,
          colors=brewer.pal(8, "Dark2"))
