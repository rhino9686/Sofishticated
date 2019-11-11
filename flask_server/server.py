from flask import Flask, request, jsonify, redirect
from tank import Tank
## Setup Server
app = Flask(__name__)

##Setup tank construct
myTank = Tank()

## Home route, use to check connection with a code?
@app.route("/")
def hello():
    return "Hello from server!"

## handler for tank making a PUT request for temperature 
@app.route("/fromTank/sendTemp")
def getTempFromTank():
    return "temp retrieved from tank"

## handler for tank making a PUT request for pH
@app.route("/fromTank/sendpH")
def getPhFromTank():
    return "pH retrieved from tank"

## handler for tank making a GET request to know if it's time to check chemicals 
@app.route("/fromTank/check")
def checkTankChemicals():
    return "checking tank chemicals"

@app.route("/fromApp/requestTemp")
def sendTempToApp():
    return "temp sent to app"

@app.route("/fromApp/requestpH")
def sendPhToApp():
    return "pH sent to app"

##@app.route("/fromApp/requestRando",methods = ['POST'])
def sendRandoToApp():
    myRandStr = str(random())
    print("Returning rand val " + myRandStr)
    return jsonify({"randVal": myRandStr})

@app.route("/fromApp/requestRando",methods = ['POST'])
def sendRandoFromChip():
    return redirect("http://www.example.com", code=302)

@app.route("/fromApp/requestCheck")
def App():
    return "chemicals set to be check"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port =5000)
