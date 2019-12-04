
class Tank:
    
    def __init__(self):
        self.currentTemp = 7300
        self.currentpH = 650
        self.ammoVal = 0
        self.nitrateVal = 0
        self.nitriteVal = 0
        self.tempHistory = []
        self.pH_history = []
        
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

        
        
def convertToFahrenheit(numCelcius):
    numCelcius = numCelcius / 100
    numFar = (9/5)*numCelcius + 32
    return numFar * 100



