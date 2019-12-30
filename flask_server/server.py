from flask import Flask, request, jsonify, redirect
from tank import Tank, convertToFahrenheit, parseChemStr, parseTempAvg
from random import random
import requests
## Setup Server
app = Flask(__name__)

## Setup tank construct
myTank = Tank()
myTank.rando = 3

## define Wi-Fi chip IP address

WIFI_IP = "35.6.179.38"

# Home route, use to check connection with a code?
@app.route("/", methods = ['POST'])
def hello():
    return "Hello from server!"

# handler for tank making a POST request for temperature 
@app.route("/fromTank/sendTemp", methods = ['POST'])
def getTempFromTank():
    tempStr = str(request.data)
    temperatureStr = tempStr[7:11] ## check this val
    try:
        celciusNum = int(temperatureStr)
        farNum = convertToFahrenheit(celciusNum)
        myTank.setTemp(farNum) 
    except:
         print( "Temp: " + temperatureStr)
    print( "Temp: " + temperatureStr)
    return "temp received" #return val is meaningless

# handler for tank sending pH value
@app.route("/fromTank/sendpH", methods = ['POST'])
def getPhFromTank():
    phStr = str(request.data)
    phValStr = phStr[5:8] ##check this val
    try:
        myTank.setPH(int(phValStr)) 
    except:
        print(phValStr)

    print("pH: " + phValStr)
    return "pH received"

# handler for tank sending Ammonia value
@app.route("/fromTank/sendChems", methods = ['POST'])
def getChemsFromTank():
    chemStr = str(request.data)
    try:
        ammonia, nitrate, nitrite = parseChemStr(chemStr)
        print(ammonia)
        myTank.setNitrite(nitrite)
        myTank.setNitrate(nitrate)
        myTank.setAmmo(ammonia)
    except:
        "chem vals didn't line up for int indexing"
    return "chems retrieved from tank"

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
    numStr = randStr[2]
   ## myTank.rando = int(numStr)
   ## print(myTank.rando)
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
    dest_url = "http://" + WIFI_IP + "/requestChems"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "ff"
    response = requests.post(dest_url, data=data, headers=headers)
    ammoniaRes = myTank.getAmmo()
    return jsonify({"ammo": str(ammoniaRes)})

# handler for app requesting an Nitrate reading 
@app.route("/fromApp/requestNitrate",methods = ['POST'])
def sendNitrateToApp():
    dest_url = "http://" + WIFI_IP + "/requestChems"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "ff"
   ## response = requests.post(dest_url, data=data, headers=headers)
    nitrateRes = myTank.getNitrate()
    return jsonify({"nitrate": str(nitrateRes)})


# handler for app requesting an Nitrite reading 
@app.route("/fromApp/requestNitrite",methods = ['POST'])
def sendNitriteToApp():
    dest_url = "http://" + WIFI_IP + "/requestChems"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "ff"
    response = requests.post(dest_url, data=data, headers=headers)
    nitriteRes = myTank.getNitrite()
    return jsonify({"nitrite": str(nitriteRes)})



# handler for app prompting the Wi-fi chip to send temp/pH
@app.route("/fromApp/requestCheck", methods = ['POST'])
def promptChipForVals():
    dest_url = "http://" + WIFI_IP + "/requestVals"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(3)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})


# handler for app prompting an Ammonia Test
@app.route("/fromApp/promptAmmonia", methods = ['POST'])
def promptChipForAmmonia():
    dest_url = "http://" + WIFI_IP + "/promptAmmonia"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(4)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})


# handler for app prompting an Nitrate Test
@app.route("/fromApp/promptNitrate", methods = ['POST'])
def promptChipForNitrate():
    dest_url = "http://" + WIFI_IP + "/promptNitrate"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(5)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})


# handler for app prompting an Nitrite Test
@app.route("/fromApp/promptNitrite", methods = ['POST'])
def promptChipForNitrite():
    dest_url = "http://" + WIFI_IP + "/promptNitrite"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(5)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"check": det})


# handler for app prompting a reset of the tank's settings
@app.route("/fromApp/requestReset", methods =['POST'])
def sendResetCommand():
    dest_url = "http://" + WIFI_IP + "/requestReset"
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    data = "blank"
    det = str(4)
    response = requests.post(dest_url, data=data, headers=headers)
    return jsonify({"reset": det})


# handler for app sending a new temp range
@app.route("/fromApp/sendAvg", methods =['POST'])
def sendTempAvgToTank():
    dest_url = "http://" + WIFI_IP + "/sendAvg"
    headers = {'Content-type': 'application/json', 'Accept':'text/plain'}
    rawTempData = str(request.data)
    myTempStr = parseTempAvg(rawTempData)
    data = {"temp": myTempStr}

    det = str(4)
    response = requests.post(dest_url, json=data, headers=headers)
    return jsonify({"avg": det})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port =5000)
