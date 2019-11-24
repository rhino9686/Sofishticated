from flask import Flask, request, jsonify, redirect
from tank import Tank
from random import random
## Setup Server
app = Flask(__name__)

## Setup tank construct
myTank = Tank()

myTank.rando = 3


## define Wi-Fi chip IP address

WIFI_IP = "35.6.179.38"

## Home route, use to check connection with a code?
@app.route("/")
def hello():
    return "Hello from server!"

## handler for tank making a PUT request for temperature 
@app.route("/fromTank/sendTemp")
def getTempFromTank():
    tempStr = str(request.data)
    temperatureStr = tempStr[2] ## check this val
    print(tempStr)
    return "temp received" #return val is meaningless

## handler for tank making a PUT request for pH
@app.route("/fromTank/sendpH")
def getPhFromTank():
    phStr = str(request.data)
    phValStr = phStr[2] ##check this val
    return "pH retrieved"

@app.route("/fromTank/sendAmmonia")
def getAmmoniaFromTank():
    ammonStr = str(request.data)
    ammonValStr = ammonStr[2] ##check this val
    return "pH retrieved from tank"

@app.route("/fromTank/sendNitrate")
def getNitrateFromTank():
    nitStr = str(request.data)
    nitrateStr = nitStr[2] ##check this val
    return "pH retrieved from tank"


## handler for tank making a GET request to know if it's time to check chemicals 
@app.route("/fromTank/check")
def checkTankChemicals():
    return "Y"



## handler for tank making a GET request to know if it's time to check chemicals 
@app.route("/fromTank/sendRando", methods = ['POST'])
def getRando():
    randStr = str(request.data)
    print(randStr)
    ##numStr = randStr[2]
    ##myTank.rando = int(numStr)
    ##print(myTank.rando)
    return "checking tank chemicals"



@app.route("/fromApp/requestTemp",methods = ['POST'])
def sendTempToApp():
    myTempStr = str(myTank.getTemp())
    print("Returning Temp val " + myTempStr)
    return jsonify({"temp": myTempStr})

@app.route("/fromApp/requestpH",methods = ['POST'])
def sendPhToApp():
    mypHStr = str(myTank.getPH())
    print("Returning pH val " + mypHStr)
    return jsonify({"pH": mypHStr})

@app.route("/fromApp/requestRando",methods = ['POST'])
def sendRandoToApp():
    myRandStr = str(myTank.rando)
    print("Returning rand val " + myRandStr)
    return jsonify({"randVal": myRandStr})

@app.route("/fromApp/requestCheck")
def promptChipForVals():
    dest_url = "http://" + WIFI_IP + ":5000/requestVals"

    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    response = request.post(dest_url, data=data, headers=headers)
    return jsonify({"data": "data_requested"})



if __name__ == "__main__":
    app.run(host='0.0.0.0', port =5000)
