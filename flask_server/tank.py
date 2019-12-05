
class Tank:
    
    def __init__(self):
        self.currentTemp = 7300
        self.currentpH = 650
        self.ammoVal = 0
        self.nitrateVal = 0
        self.nitriteVal = 0
        
    ## Getters
    def getTemp(self):
        return self.currentTemp
    
    def getPH(self):
        return self.currentpH

    def getAmmo(self):
        return self.ammoVal

    def getNitrate(self):
        return self.nitrateVal

    def getNitrite(self):
        return self.nitriteVal
    

    # Setters

    def setTemp(self,temperature):
        self.currentTemp = temperature
    
    def setPH(self,pH_val):
        self.currentpH = pH_val

    def setAmmo(self, ammo_in ):
        self.ammoVal = ammo_in

    def setNitrate(self, nitrate_in):
        self.nitrateVal = nitrate_in

    def setNitrite(self, nitrite_in):
        self.nitriteVal = nitrite_in

def convertToCelcius(numFar):
    numFar = numFar / 100
    numCelcius = (numFar - 32)*(5/9)
    return numCelcius * 100
        
def convertToFahrenheit(numCelcius):
    numCelcius = numCelcius / 100
    numFar = (9/5)*numCelcius + 32
    return numFar * 100

def parseChemStr(str):
    ammonia = str[10:13]
    #print(ammonia)

    nitrate = str[23:25]
    #print(nitrate)

    nitrite = str[36:38]
    #print(nitrite)

    return int(ammonia), int(nitrate), int(nitrite)

def parseTempAvg(stringNum):
    temp = stringNum[17: 25]
    print ("F: " + temp)
    numFar = float(temp)
    numCelcius = convertToCelcius(numFar)
    strNum = str(int(numCelcius))
    print(" C: " + strNum)
    return " " + strNum + "     "

if __name__ == "__main__":
    stre = "b'ammonia:10   nitrate:15   nitrite:20   '"
    parseChemStr(stre)
