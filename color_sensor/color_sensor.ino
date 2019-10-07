class ColorSensor{
private:
  int s0 = 3;
  int s1 = 4;
  int s2 = 5;
  int s3 = 6;
  int flag, counter;
  byte countR, countG, countB;

  void ISR_INTO()
  {
    counter++;
  }

  void timer0_init()
  {
    TCCR2a = 0x00;
    TCCR2B = 0x07;
    TCNT2 = 100;
    TIMSK2 = 0x01;
  }
  
public:
  ColorSensor()
  {
    counter = 0;
    countR = 0; countG = 0; countB = 0;
    flag = 0;
    Serial.begin(115200);
    pinMode(s0, output);
    pinMode(s1, output);
    pinMode(s2, output);
    pinMode(s3, output);
  }

  void TCS()
  {
    flag = 0;
    digitalWrite(s1, HIGH);
    digitalWrite(s0, HIGH);
    digitalWrite(s2, LOW);
    digitalWrite(s3, LOW);
    attachInterrupt(0, ISR_INTO, CHANGE);
    timer0_init();
  }
};

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}
