#include "WProgram.h"
// define the pins we use
#define incSwitchUpPin 9
#define incSwitchDownPin 10

void setup();
void loop();
void readIncSwitch(int switchPin, byte boolean, int buttonState);
void turnAllOff();
void setLED(int aNumber);
int incButtonStateUp, incButtonStateDown;     // variable to hold the button state
int counter = 0; 				// variable the keeps number number in the display

void setup() { 
	pinMode(incSwitchUpPin, INPUT);
	pinMode(incSwitchDownPin, INPUT);

	incButtonStateUp = digitalRead(incSwitchUpPin);   // read the initial state
	incButtonStateDown = digitalRead(incSwitchDownPin);   // read the initial state
	for(int i=2; i<9; i++) { // initializes pins 0 to 7 as outputs
		pinMode(i, OUTPUT);
	}
}

void loop() {
	readIncSwitch(incSwitchUpPin, 1, incButtonStateUp);
	readIncSwitch(incSwitchDownPin, 0, incButtonStateDown);
	delay(200);
}

// Read a Switch Wait
void readIncSwitch(int switchPin, byte boolean, int buttonState) {
	turnAllOff();
	setLED(counter);
	int val = digitalRead(switchPin);      // read input value and store it in val
	delay(10);                         // 10 milliseconds is a good amount of time
	int val2 = digitalRead(switchPin);     // read the input again to check for bounces
	if (val == val2) {                 // make sure we got 2 consistant readings!
		if (val != buttonState) {          // the button state has changed!
			if (val == LOW) {          // check if the button is pressed
				if (boolean == 1) {
					if (counter < 9) {
						counter++;
					}
					else {
						counter = 0;
					}	
				}
				else {
					if (counter > 0) {
						counter--;
					}
					else {
						counter = 9;
					}
				}
			}
		}
		buttonState = val;                 // save the new state in our variable
	} // Switch End
}

void turnAllOff() { // function to turn off all the lights
	for(int i=2; i<9; i++) {
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

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

