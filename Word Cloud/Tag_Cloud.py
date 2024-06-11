#
# Title: Tag Cloud Software
# 
# Description: After Researching about Python modules, I stumbled across wikipeda
# which I found to be an interesting module which was easy to learn to use and from this 
# decided to research ways on how to implent a simple program utilizing it.
#
# Version : 1.0
# Made by: Carlo San Buenaventura
#
# Req : Need to Install Pillow, Wikipedia API, and Word Cloud because PytagCloud doesnt work properly in Python 3

import sys
import numpy
from PIL import Image
import matplotlib.pyplot as plt
import wikipedia
from wordcloud import WordCloud, STOPWORDS
# Get wiki data
def searchWiki(topic):
    try:
        wiki = wikipedia.search(topic)[0]
        page = wikipedia.page(wiki)
        return page.content
    except:
        return False


print("==Welcome to Wiki Word Cloud Generator==")
content = False
while not content:
    topic = input("\nEnter topic you would like to generate from: ").upper() #ask topic
    content = searchWiki(topic) #check if topic exist
    if not content:
        print("\nTopic doesnt exist or cant be found using wiki api. ")

filename = input("\nEnter name of file you would like to generate to: ").upper() #ask file name
filename = filename + ".png" #turn into png
wMask = numpy.array(Image.open("Black.png"))
wc = WordCloud(stopwords=STOPWORDS,
               mask= wMask,
               background_color="white",
               contour_color= "black",
               contour_width= 3,
               min_font_size=3,
               max_words=200
               )
wc.generate(content).to_file(filename) # save as image

#display into Word Cloud window
plt.figure(facecolor= None)
plt.imshow(wc.generate(content))
plt.axis("off")
plt.show()

