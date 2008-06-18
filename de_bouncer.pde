/*
 *  Bike light, revision 3: blinky
 */

int switchPin = 2;              // switch is connected to pin 2
int led1Pin = 12;
int led2Pin = 11;
int led3Pin = 10;
int led4Pin = 9;
int led5Pin = 8;

int val;                        // variable for reading the pin status
int val2;                       // variable for reading the delayed status
int buttonState;                // variable to hold the button state

int lightMode = 0;              // What mode is the light in?

void setup() {
  pinMode(switchPin, INPUT);    // Set the switch pin as input

  pinMode(led1Pin, OUTPUT);
  pinMode(led2Pin, OUTPUT);
  pinMode(led3Pin, OUTPUT);
  pinMode(led4Pin, OUTPUT);
  pinMode(led5Pin, OUTPUT);
  
  Serial.begin(9600);           // Set up serial communication at 9600bps
  buttonState = digitalRead(switchPin);   // read the initial state
}

void loop(){
  val = digitalRead(switchPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  val2 = digitalRead(switchPin);     // read the input again to check for bounces
  if (val == val2) {                 // make sure we got 2 consistant readings!
    if (val != buttonState) {          // the button state has changed!
      if (val == LOW) {                // check if the button is pressed
        if (lightMode == 0) {          // light is off
          lightMode = 1;               // turn light on!
        } else {
          lightMode = 0;               // turn light off!
        }
      }
    }
    buttonState = val;                 // save the new state in our variable
  }

  // Now do whatever the lightMode indicates
  if (lightMode == 1) {
    digitalWrite(led1Pin, HIGH);
    digitalWrite(led2Pin, HIGH);
    digitalWrite(led3Pin, HIGH);
    digitalWrite(led4Pin, HIGH);
    digitalWrite(led5Pin, HIGH);
    delay(100);
    digitalWrite(led1Pin, LOW);
    digitalWrite(led2Pin, LOW);
    digitalWrite(led3Pin, LOW);
    digitalWrite(led4Pin, LOW);
    digitalWrite(led5Pin, LOW);
    delay(100);
  }
  // If lightmode is 0, we dont have to do anything because the LEDs are already off!
}
