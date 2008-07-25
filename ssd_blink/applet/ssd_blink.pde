/*
 *  Counting presses
 */
int switchPin = 10;          // switch is connected to pin 2
int val, val2;               // variable for reading the pin status
int buttonState;             // variable to hold the button state
int counter = 0;          	 // how many times the button has been pressed

void setup() {
	pinMode(switchPin, INPUT);  // Set the switch pin as input

	Serial.begin(9600);         // Set up serial communication at 9600bps
	buttonState = digitalRead(switchPin);   // read the initial state
	for(int i=2; i<9; i++) { 	// initializes pins 0 to 7 as outputs
		pinMode(i, OUTPUT);
	}
}

void loop(){
	turnAllOff();
	setLED(counter);
	val = digitalRead(switchPin);      // read input value and store it in val
	delay(10);                         // 10 milliseconds is a good amount of time
	val2 = digitalRead(switchPin);     // read the input again to check for bounces
	if (val == val2) {                 // make sure we got 2 consistant readings!
		if (val != buttonState) {      // the button state has changed!
			if (val == LOW) {          // check if the button is pressed
				if(counter < 9) {
					counter++;         // increment the buttonPresses variable
				}
				else {
					counter = 0;
				}
			}
		}
		buttonState = val;      // save the new state in our variable
	}
}

void turnAllOff() {				// function to turn off all the lights
	for(int i=2; i<9; i++) { 	// initializes pins 0 to 7 as outputs
		digitalWrite(i, HIGH);
	}
}

void setLED(int aNumber) {
	int number = aNumber;
	if(number==0) {
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}

	if(number==1) {
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
	}

	if(number==2) {
		digitalWrite(6, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
	}

	if(number==3) {
		digitalWrite(6, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}

	if(number==4) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
	}

	if(number==5) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}

	if(number==6) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}

	if(number==7) {
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
	}

	if(number==8) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}

	if(number==9) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
	}
}
