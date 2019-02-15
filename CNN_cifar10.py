
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import keras
from keras.datasets import cifar10
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPooling2D


# In[2]:


(x_train, y_train), (x_test, y_test) = cifar10.load_data() 
row,col,lay=32,32,3
x_train = x_train.reshape(x_train.shape[0], row, col, lay)
x_test = x_test.reshape(x_test.shape[0], row, col, lay)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

y_train = keras.utils.to_categorical(y_train, 10)
actu = y_test.ravel()
y_test = keras.utils.to_categorical(y_test, 10)


# In[31]:



#Case 1
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),activation='relu', input_shape=(row, col, lay)))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(64, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])
'''
#Case 2
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),activation='relu', input_shape=(row, col, lay)))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25)) 

model.add(Flatten())
model.add(Dense(512, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])

#Case 3
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),activation='relu', input_shape=(row, col, lay)))
model.add(Dropout(0.2))
model.add(Conv2D(32, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(Dropout(0.2))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25)) 

model.add(Flatten())
model.add(Dense(512, activation='relu'))
model.add(Dropout(0.3))
model.add(Dense(10, activation='softmax'))
model.compile(loss="categorical_crossentropy", optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])
'''


# In[32]:


model_train = model.fit(x_train, y_train, batch_size=64, epochs=8, verbose=1,validation_data=(x_test,y_test))


# In[33]:


pred_y = model.predict(x_test,verbose=1)


# In[34]:


pred = np.empty(len(pred_y))
for i in range(len(pred_y)):
    max=0
    for j in range(len(pred_y[i])):   
        if pred_y[i,j]>max:
            max=pred_y[i,j]
            pred[i]=j      
        
pred = pred.astype("int8")


# In[35]:


actu = pd.Series(actu, name='Actual')
pred = pd.Series(pred, name='Predicted')
df_confusion = pd.crosstab(actu, pred)
print(df_confusion)


# In[36]:


score = model.evaluate(x_test,y_test,verbose=1)
print('Test accuracy:', score[1])

