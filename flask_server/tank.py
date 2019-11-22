
class Tank:
    
    def __init__(self):
        self.currentTemp = 7300
        self.currentpH = 650
        self.tempHistory = []
        self.pH_history = []
        
    def getTemp(self):
        return self.currentTemp
    
    def getPH(self):
        return self.currentpH
    
    def setTemp(self,temperature):
        self.currentTemp = temperature
    
    def setPH(self,pH_val):
        self.currentpH = pH_val
        

        
        
        