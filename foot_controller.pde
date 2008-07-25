/*
 * MIDI Foot Controller
 * -------------
 * Convert Arduino to a MIDI controller using various inputs and
 * the serial port as a MIDI output.
 *  
 *  pin 1 orange
 *  pin 2 braiding arround the edge
 *  pin 3 black
 *  pin 4 white
 *  pin 5 red
 *  
 * To send MIDI, attach a MIDI out jack (female DIN-5) to Arduino.
 * DIN-5 pinout is:                               _____ 
 *    pin 2 - Gnd                                /     \
 *    pin 4 - 220 ohm resistor to +5V           | 3   1 |  MIDI jack
 *    pin 5 - Arduino D1 (TX)                   |  5 4  |
 *    all other pins - unconnected               \__2__/
 *
 * Based off of Tom Igoe's work at:
 *    http://itp.nyu.edu/physcomp/Labs/MIDIOutput
 *
 * Created 25 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com
 * http://todbot.com/
 */

// what midi channel we're sending on
#define midichan         1

// general midi drum notes
#define record     38
#define overdub    39
#define mute       42
int switchA, switchB, switchC;

// define the pins we use
#define incSwitchUpPin 9
#define incSwitchDownPin 10

#define switchAPin 11
#define switchBPin 12
#define switchCPin 13

int buttonStateA, buttonStateB, buttonStateC;     // variable to hold the button state
int incButtonStateUp, incButtonStateDown;     // variable to hold the button state
int counter = 0; 				// variable the keeps number number in the display

void setup() {
	pinMode(switchAPin, INPUT);
	pinMode(switchBPin, INPUT);
	pinMode(switchCPin, INPUT);
	
	pinMode(incSwitchUpPin, INPUT);
	pinMode(incSwitchDownPin, INPUT);
  
	Serial.begin(31250);   // set MIDI baud rate
	
	buttonStateA = digitalRead(switchAPin);   // read the initial state
	buttonStateB = digitalRead(switchBPin);   // read the initial state
	buttonStateC = digitalRead(switchCPin);   // read the initial state

	incButtonStateUp = digitalRead(incSwitchUpPin);   // read the initial state
	incButtonStateDown = digitalRead(incSwitchDownPin);   // read the initial state
	
	for(int i=2; i<9; i++) { // initializes pins 0 to 7 as outputs
		pinMode(i, OUTPUT);
	}
}

void loop() {
	readMidiSwitch(switchAPin, switchA, buttonStateA);
	readMidiSwitch(switchBPin, switchB, buttonStateB);
	readMidiSwitch(switchCPin, switchC, buttonStateC);
	
	readIncSwitch(incSwitchUpPin, 1, incButtonStateUp);
	readIncSwitch(incSwitchDownPin, 0, incButtonStateDown); 
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
	delay(175);
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
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==1) {
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==2) {
		digitalWrite(6, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==3) {
		digitalWrite(6, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==4) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==5) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==6) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==7) {
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==8) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(8, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}

	if(number==9) {
		digitalWrite(6, LOW);
		digitalWrite(5, LOW);
		digitalWrite(4, LOW);
		digitalWrite(3, LOW);
		digitalWrite(7, LOW);
		digitalWrite(2, LOW);
		switchA = record;
		switchB = overdub;
		switchC = mute;
	}
}

// Read a Switch Wait
void readMidiSwitch(int switchPin, byte note, int buttonState) {
	// Switch 3 Start
	int val = digitalRead(switchPin);      // read input value and store it in val
	delay(10);                         // 10 milliseconds is a good amount of time
	int val2 = digitalRead(switchPin);     // read the input again to check for bounces
	if (val == val2) {                 // make sure we got 2 consistant readings!
		if (val != buttonState) {          // the button state has changed!
			if (val == LOW) {            // check if the button is pressed
				noteOn(midichan,  note, 64);
				Serial.println("on");
			}
			else {
				noteOff(midichan, note, 0);
				Serial.println("off");
			}
		}
		buttonState = val;                 // save the new state in our variable
	} // Switch End
}

// Send a MIDI note-on message.  Like pressing a piano key
void noteOn(byte channel, byte note, byte velocity) {
	midiMsg( (0x80 | (channel<<4)), note, velocity);
}

// Send a MIDI note-off message.  Like releasing a piano key
void noteOff(byte channel, byte note, byte velocity) {
	midiMsg( (0x80 | (channel<<4)), note, velocity);
}

// Send a general MIDI message
void midiMsg(byte cmd, byte data1, byte data2) {
	Serial.print(cmd, BYTE);
	Serial.print(data1, BYTE);
	Serial.print(data2, BYTE);
}