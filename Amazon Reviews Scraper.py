
# coding: utf-8

# In[1]:


from urllib.request import Request, urlopen
import urllib.request
import urllib.parse
import urllib.error
import numpy
from bs4 import BeautifulSoup
import ssl
import json
import requests

ctx = ssl.create_default_context()
ctx.check_hostname = False


# In[3]:


ratings=[0] * 5010
reviews=[''] * 5010
count = 0
num = 5000
def scrape(bsoup, count):
    for divs in bsoup.findAll('div', attrs={'class': 'a-section review','data-hook': 'review'}):
        if (count >= num):
            break
        count = count + 1            
        for span_tags in divs.findAll('span', attrs={'class': 'a-icon-alt'}):        
            rating = span_tags.text.strip()
            ratings[count] = rating[0]
        for span_tags in divs.findAll('span', attrs={'data-hook': 'review-body'}):
            review = span_tags.text.strip()
            reviews[count] = review
    return count
        
amazon = "https://www.amazon.com"
url="https://www.amazon.com/VTech-CS6114-Cordless-Waiting-Handset/product-reviews/B004OA758C/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews"
html = urllib.request.urlopen(url, context=ctx).read()
soup = BeautifulSoup(html, 'html.parser')

count = scrape(soup, count)
flag=True
while flag:
    flag=False
    for li in soup.findAll('li', attrs={'class':'a-last'}):
        for a in li.findAll('a'):
            flag=True
            url = a['href']
            soup = BeautifulSoup(urllib.request.urlopen(amazon+url, context=ctx).read(), 'html.parser')
            count = scrape(soup, count)            
    if (count >= num):
        flag = False
        break                    
  


# In[ ]:


data = [[0] * 2 for row in range(5000)]
for i in range(5000):
    data[i][0] = ratings[i+1]
    data[i][1] = reviews[i+1]
with open('data', 'w') as outfile:
    json.dump(data, outfile, indent=4)


# In[ ]:


'''
data = [ [0] * 2 for row in range(5000) ]
count = -1
num = 5000
def scrape(bsoup, count):
    for divs in bsoup.findAll('div', attrs={'class': 'a-section review','data-hook': 'review'}):
        if (count >= num):
            break
        count = count + 1            
        for span_tags in divs.findAll('span', attrs={'class': 'a-icon-alt'}):        
            rating = span_tags.text.strip()
            data[count][0] = rating[0]
        for span_tags in divs.findAll('span', attrs={'data-hook': 'review-body'}):
            review = span_tags.text.strip()
            data[count][1] = review
    return count
        
amazon = "https://www.amazon.com"
url="https://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=phone"
html = urllib.request.urlopen(url, context=ctx).read()
soup = BeautifulSoup(html, 'html.parser')
#print(soup)
#for div in soup.findAll('div', attrs={'class':'s-item-container'}):
for a1 in soup.findAll('a', attrs={'class':'a-size-small a-link-normal a-text-normal'}):
    url1 = a1['href'] 
    if url1[-7:-1] != "Review":
        continue
    print(url1)
    soup1 = BeautifulSoup(urllib.request.urlopen(url1, context=ctx).read(), 'html.parser')    
    for a2 in soup1.findAll('a', attrs={'class':'a-link-emphasis a-text-bold'}):
        url2 = a2['href']
        soup2 = BeautifulSoup(urllib.request.urlopen(amazon+url2, context=ctx).read(), 'html.parser')        
        count = scrape(soup2, count)
        if (count >= num):
            break;
               
        flag=True
        while flag:
            flag=False
            for li in soup2.findAll('li', attrs={'class':'a-last'}):
                for a3 in li.findAll('a'):
                    flag=True
                    url3 = a3['href']
                    soup2 = BeautifulSoup(urllib.request.urlopen(amazon+url3, context=ctx).read(), 'html.parser')
                    count = scrape(soup2, count)
            if (count >= num):
                flag = False
                break                    
        if (count >= num):
            break  
    print(count)
    if (count >= num):
            break
 '''   

