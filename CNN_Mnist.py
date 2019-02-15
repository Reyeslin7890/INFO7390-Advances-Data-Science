
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPooling2D


# In[2]:


(train_x, train_y), (test_x, test_y) = mnist.load_data()
#Input Layer
train_x = train_x.reshape(train_x.shape[0], 28, 28, 1)
test_x = test_x.reshape(test_x.shape[0], 28, 28, 1)
train_x = train_x.astype('float32')
test_x = test_x.astype('float32')
train_x /= 255
test_x /= 255

train_y = keras.utils.to_categorical(train_y, 10)
actu = test_y
test_y = keras.utils.to_categorical(test_y, 10)


# In[8]:


'''
#Case 1
model = Sequential()
model.add(Conv2D(16, kernel_size=(3, 3), activation='relu', input_shape=(28, 28, 1)))
print(model.output_shape)
model.add(Conv2D(32, (3, 3), activation='relu'))
print(model.output_shape)
model.add(MaxPooling2D(pool_size=(2, 2)))
print(model.output_shape)
model.add(Dropout(0.25))
model.add(Flatten())
print(model.output_shape)
model.add(Dense(64, activation='relu'))
print(model.output_shape) 
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
print(model.output_shape)
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])


#Case 2
model = Sequential()
model.add(Conv2D(16, kernel_size=(3, 3), activation='relu', input_shape=(28, 28, 1)))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(Conv2D(128, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(64, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])

'''


#Case 3
model = Sequential()
model.add(Conv2D(16, kernel_size=(3, 3), activation='relu', input_shape=(28, 28, 1)))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(Dropout(0.25))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(64, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])


# In[9]:


model_log = model.fit(train_x, train_y, batch_size=128, epochs=8, verbose=1)


# In[10]:


pred_y = model.predict(test_x)
pred = np.empty(len(pred_y))
for i in range(len(pred_y)):
    max=0
    for j in range(len(pred_y[i])):
        if pred_y[i,j]>max:
            max=pred_y[i,j]
            pred[i] = j     
pred = pred.astype("int8")


# In[11]:


actu = pd.Series(actu, name='Actual')
pred = pd.Series(pred, name='Predicted')
df_confusion = pd.crosstab(actu, pred)
print(df_confusion)


# In[12]:


score = model.evaluate(test_x,test_y,verbose=1)
print('Test accuracy:', score[1])

