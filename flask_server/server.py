from flask import Flask, request, jsonify, redirect
from tank import Tank
from random import random
import requests
## Setup Server
app = Flask(__name__)

## Setup tank construct
myTank = Tank()
myTank.rando = 3

## define Wi-Fi chip IP address

WIFI_IP = "35.6.190.156"

# Home route, use to check connection with a code?
@app.route("/", methods = ['POST'])
def hello():
    return "Hello from server!"

# handler for tank making a POST request for temperature 
@app.route("/fromTank/sendTemp", methods = ['POST'])
def getTempFromTank():
    tempStr = str(request.data)
    temperatureStr = tempStr[2:6] ## check this val
    print("Temp received from tank: " + temperatureStr)
    myTank.setTemp(int(temperatureStr)) 
    return "temp received" #return val is meaningless

# handler for tank sending pH value
@app.route("/fromTank/sendpH", methods = ['POST'])
def getPhFromTank():
    phStr = str(request.data)
    phValStr = phStr[2:5] ##check this val
    myTank.setPH(int(phValStr)) 
    print("pH received from tank: " + phValStr)
    return "pH received"

# handler for tank sending Ammonia value
@app.route("/fromTank/sendAmmonia", methods = ['POST'])
def getAmmoniaFromTank():
    ammonStr = str(request.data)
    ammonValStr = ammonStr[2] ##check this val
   
    return "pH retrieved from tank"

# handler for tank sending Nitrate value
@app.route("/fromTank/sendNitrate", methods = ['POST'])
def getNitrateFromTank():
    nitStr = str(request.data)
    nitrateStr = nitStr[2] ##check this val
    return "pH retrieved from tank"

# handler for tank sending a random number to server
@app.route("/fromTank/sendRando", methods = ['POST'])
def getRando():
    randStr = str(request.data)
    print(randStr)
    ##numStr = randStr[2]
    ##myTank.rando = int(numStr)
    ##print(myTank.rando)
    return "random number received"

# handler for app requesting a temperature reading
@app.route("/fromApp/requestTemp",methods = ['POST'])
def sendTempToApp():
    myTempStr = str(myTank.getTemp())
    print("Returning Temp val " + myTempStr)
    return jsonify({"temp": myTempStr})

# handler for app requesting a pH reading 
@app.route("/fromApp/requestpH",methods = ['POST'])
def sendPhToApp():
    mypHStr = str(myTank.getPH())
    print("Returning pH val " + mypHStr)
    return jsonify({"pH": mypHStr})

# handler for app requesting a random number 
@app.route("/fromApp/requestRando",methods = ['POST'])
def sendRandoToApp():
    myRandStr = str(myTank.rando)
    print("Returning rand val " + myRandStr)
    return jsonify({"randVal": myRandStr})

# handler for app requesting an Ammonia reading 
@app.route("/fromApp/requestAmmonia",methods = ['POST'])
def sendAmmoToApp():
    myRandStr = str(myTank.getAmmo())
    print("Returning rand val " + myRandStr)
    return jsonify({"ammo": myRandStr})


# handler for app prompting a server check
@app.route("/fromApp/requestCheck", methods = ['POST'])
def promptChipForVals():
    dest_url = "http://" + WIFI_IP + "/requestVals"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(3)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})

# handler for app prompting a serverChem check
@app.route("/fromApp/requestChemCheck", methods = ['POST'])
def promptChipForChemVals():
    dest_url = "http://" + WIFI_IP + "/requestChemCheck"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(4)
   ## response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})

# handler for app prompting a serverChem check
@app.route("/fromApp/requestReset", methods = ['POST'])
def sendResetCommand():
    dest_url = "http://" + WIFI_IP + ":5000/requestReset"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(4)
   ## response = request.post(dest_url, data=data, headers=headers)
    return jsonify({"reset": det})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port =5000)
