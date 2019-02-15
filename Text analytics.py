
# coding: utf-8

# In[1]:


import nltk
import numpy as np
import data
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB

train = data.mylist
posfile = open('D:/NEU/7390 Advances Data Science/opinion-lexicon-English/positive-words.txt', 'r')
negfile = open('D:/NEU/7390 Advances Data Science/opinion-lexicon-English/negative-words.txt', 'r')
pos_set = posfile.read().split('\n')
neg_set = negfile.read().split('\n')
posfile.close()
negfile.close()


# In[2]:


def textAnaly(s):
    pos_count = 0
    neg_count = 0
    for str in s:
        for pos in pos_set:
            if (str == pos):
                pos_count += 1
        for neg in neg_set:
            if (str == neg):
                neg_count += 1
    return pos_count, neg_count


# In[3]:


result1 = [''] * 5000
result2 = [''] * 5000
for i in range(5000):
    if int(train[i][0])>3:
        result1[i] = 'pos'
    else:
        result1[i] = 'neg'

for i in range(5000):
    s = train[i][1].split(' ')
    pos, neg = textAnaly(s)
    if pos>neg:
        result2[i] = 'pos'
    else:
        result2[i] = 'neg'


# In[4]:


reviews = []
for i in range(5000):
    reviews.append(train[i][1])

vectorizer = CountVectorizer()
X = vectorizer.fit_transform(reviews).toarray()


xtrain, xtest = X[:4000], X[4000:]
y1train, y1test = result1[:4000], result1[4000:]
y2train, y2test = result2[:4000], result2[4000:]


# In[7]:



clf1 = MultinomialNB()
clf1.fit(xtrain, y1train)
pred1 = clf1.predict(xtest)

clf2 = MultinomialNB()
clf2.fit(xtrain, y2train)
pred2 = clf2.predict(xtest)

count1 = 0
count2 = 0
for i in range(1000):
    if (pred1[i]==y1test[i]):
        count1 += 1
    if (pred2[i]==y2test[i]):
        count2 += 1
        
from sklearn.metrics import confusion_matrix,accuracy_score

print(confusion_matrix(y1test, pred1))
print(confusion_matrix(y2test, pred2))
print("Accuracy Score: ",accuracy_score(y1test,pred1))
print("Accuracy Score: ",accuracy_score(y2test,pred2))

