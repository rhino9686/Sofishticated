
class Tank {
  //We store everything as a integer here, will be the actual value multiplied by 100 to get 2 decimal places
  int temperature;
  int pH;


 public:
  //Constructor
  Tank(int temp_in, int pH_in  ) {
     temperature = temp_in;
     pH = pH_in;
  }
  //Getters and Setters
  int getTemp(){
     return temperature;
  }


  void setTemp(int temp_in ) {
      temperature = temp_in;
  }
  
  int getpH() {
    return pH
  }

  void setpH(int pH_in) {
     pH = pH_in;
  }

};
