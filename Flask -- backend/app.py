import cv2
import numpy as np
from flask import Flask,request,jsonify
import Predictor

app = Flask(__name__)
 
   

@app.route('/')
@app.route('/index')
def landingpage():
    return "<h1 style='text-align:center;'>Solving Sudokus</h1>"

@app.route('/solver', methods=['POST'])
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
        

if __name__ == '__main__':
    app.run(debug=True)