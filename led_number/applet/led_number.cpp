#include "WProgram.h"
// 7 segment LED display
// by Jose Ojeda
// common cathode type

void setup();
void loop();
void turnAllOff();
int setLED(int aNumber);
int number = 0; // variable the keeps number number in the display

void setup() { 
	for(int i=1; i<8; i++) { // initializes pins 0 to 7 as outputs
		pinMode(i, OUTPUT);
	}
}

void loop() {
	turnAllOff(); // turns the display off
	setLED(number);

	delay(1000); // waits for 1000 milli seconds
	number++; // increments the variable to show

	if(number > 9) { // check for the range, if greater then 9 goes back to 0s
		number = 0;
	}
}

void turnAllOff() { // function to turn off all the lights
	for(int i=1; i<8; i++) { // initializes pins 0 to 7 as outputs
		digitalWrite(i, HIGH);
	}
}

int setLED(int aNumber) {
	number = aNumber;
	if(number==0) {
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(7, LOW);
		digitalWrite(1, LOW);
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
		digitalWrite(1, LOW);
		digitalWrite(7, LOW);
	}

	if(number==3) {
		digitalWrite(6, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
		digitalWrite(1, LOW);
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
		digitalWrite(2, LOW);
		digitalWrite(1, LOW);
	}

	if(number==6) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(2, LOW);
		digitalWrite(1, LOW);
		digitalWrite(7, LOW);
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
		digitalWrite(2, LOW);
		digitalWrite(1, LOW);
		digitalWrite(7, LOW);
	}

	if(number==9) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
		digitalWrite(1, LOW);
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

