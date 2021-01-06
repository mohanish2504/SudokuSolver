import socket
import cv2
import os
import numpy as np
from flask import Flask,request,jsonify
import Predictor

app = Flask(__name__)


@app.route('/', methods=['POST'])
def predict():
    if request.method == 'POST':
        file = request.files.get('image').read()
        npimg = np.fromstring(file, np.uint8)
        img = cv2.imdecode(npimg,cv2.IMREAD_COLOR)
        result = Predictor.predict(img)
        response = {}
        if not result['sudokufound']:
            response = {
                "sudokufound":False,
                "statusCode":200,
                "sudoku":result['sudoku']
                }
        else: 
            response = {
                 "sudokufound":True,
                "statusCode":200,
                "sudoku":result['sudoku']
            }
        return jsonify(response)
        
hostip = socket.gethostbyname(socket.gethostname())
port= "8888"
ip = hostip+":"+port
print(ip)
app.run(debug=False,host=hostip,port=8888)