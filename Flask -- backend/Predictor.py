# -*- coding: utf-8 -*-
"""
Created on Wed Jan  6 16:05:57 2021

@author: Mohan
"""

import cv2
import numpy as np
from tensorflow.keras.models import load_model

height = 450
width = 450
blankImg = np.zeros((height,width,3),np.uint8)
def predict(img):
    img = cv2.resize(img,(width,height))
    blankImg = np.zeros((height,width,3),np.uint8)
    
    ##### Preprocessing Image
    imgGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    imgBlur = cv2.GaussianBlur(imgGray, (5, 5), 1) 
    imgThreshold = cv2.adaptiveThreshold(imgBlur, 255, 1, 1, 11, 2) 

    
    
    #### Finding Contours
    imgContours = img.copy()
    imgBiggestCountour = img.copy()
    contours, hierarchy = cv2.findContours(imgThreshold,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cv2.drawContours(imgContours, contours, -1, (0, 255, 0), 3)
    
    #### Selecting Biggest Contour as Sudoku
    biggestContour = np.array([])
    area = 0
    
    for c in contours:
      tmp = cv2.contourArea(c)
      if tmp>50 :
          peri = cv2.arcLength(c,True)
          poly = cv2.approxPolyDP(c,0.02*peri,True)
          if area < tmp and len(poly)==4:
            biggestContour = poly
            area = tmp
    
    
    #### Reordering/Flatening
    points = biggestContour
    points = points.reshape((4,2))
    newContour = np.zeros((4,1,2),dtype=np.int32) 
    add = points.sum(1)
    newContour[0] = points[np.argmin(add)]
    newContour[3] = points[np.argmax(add)]
    diff = np.diff(points,axis=1)
    newContour[1] = points[np.argmin(diff)]
    newContour[2] = points[np.argmax(diff)]
    biggestContour = newContour
    tmp = img.copy()
    cv2.drawContours(tmp,newContour , -1, (0, 255, 0), 3)

    
    
    
    #### Splitting cells and checking app built in 
    if biggestContour.size!=0 :
      cv2.drawContours(imgBiggestCountour, biggestContour, -1, (0, 0, 255), 25)
      pts1 = np.float32(biggestContour) 
      pts2 = np.float32([[0, 0],[width, 0], [0, height],[width, height]]) 
      matrix = cv2.getPerspectiveTransform(pts1, pts2) 
      imgWarpColored = cv2.warpPerspective(img, matrix, (width, height))
      imgDetectedDigits = blankImg.copy()
      imgWarpColored = cv2.cvtColor(imgWarpColored,cv2.COLOR_BGR2GRAY)
    else : return {'sudokufound':False,
                   'sudoku':[]
                   }
    
    
    #### Split Boxes
    imgSolvedDigits = blankImg.copy()
    digits= []
    rows = np.vsplit(imgWarpColored,9)
    for r in rows: 
      columns = np.hsplit(r,9)
      for c in columns:
        digits.append(c)
    
    #### Predicitng result for each box with CNN
    numbers = []
    model = load_model('model.h5')
    for d in digits:
      _img = np.asarray(d)
      _img = _img[4:_img.shape[0]-4,4:_img.shape[1]-4]
      _img = cv2.resize(_img,(28,28))
      _img = _img / 255
      _img = _img.reshape(1,28,28,1)
      # Continue from here when model is trained
      predictions = model.predict(_img)
      classIndex = model.predict_classes(_img)
      probabilityValue = np.amax(predictions)
    
      if probabilityValue > 0.8:
        numbers.append(classIndex[0])
      else:numbers.append(0)

    res = all(i == 0 for i in numbers) 
   # print(numbers)
   # print(res)
    if res:
        return {'sudokufound':False,
                   'sudoku':np.array(numbers).tolist()
                   }
    return {'sudokufound':True,
                   'sudoku':np.array(numbers).tolist()
                   }
        


          
    