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
#define midichan  1

#import "banks.h"

int switchA, switchB, switchC;

// define the pins we use
#define incSwitchUpPin 9
#define incSwitchDownPin 10

#define switchAPin 11
#define switchBPin 12
#define switchCPin 19

int buttonStateA, buttonStateB, buttonStateC;    // variable to hold the button state
int incButtonStateUp, incButtonStateDown;     // variable to hold the button state
int volState;
int counter = 0; 				// variable the keeps number number in the display
int valA, valA2, valB, valB2, valC, valC2;
byte control;

void setup() {
  pinMode(switchAPin, INPUT);
  digitalWrite(switchAPin, HIGH); // turn on pull up resistor
  pinMode(switchBPin, INPUT);
  digitalWrite(switchBPin, HIGH); // turn on pull up resistor
  pinMode(switchCPin, INPUT);
  digitalWrite(switchCPin, HIGH); // turn on pull up resistor

  pinMode(incSwitchUpPin, INPUT);
  digitalWrite(incSwitchUpPin, HIGH); // turn on pull up resistor
  pinMode(incSwitchDownPin, INPUT);
  digitalWrite(incSwitchDownPin, HIGH); // turn on pull up resistor

  digitalWrite(14, HIGH);  // set pullup on analog pin 0 

  Serial.begin(31250);   // set MIDI baud rate

  buttonStateA = digitalRead(switchAPin);   // read the initial state
  buttonStateB = digitalRead(switchBPin);   // read the initial state
  buttonStateC = digitalRead(switchCPin);   // read the initial state

  incButtonStateUp = digitalRead(incSwitchUpPin);   // read the initial state
  incButtonStateDown = digitalRead(incSwitchDownPin);   // read the initial state
  
  volState = analogRead(0);

  for(int i=2; i<9; i++) { // initializes pins 0 to 7 as outputs
    pinMode(i, OUTPUT);
  }
}

void loop() {
  int volVal = analogRead(0);
  if (volVal != volState) {
    midi_volume(midichan, analogRead(0) / 6.83 - 2);
  }
  volState = volVal;
 
  // Switch A Start
  int valA = digitalRead(switchAPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  int valA2 = digitalRead(switchAPin);   // read the input again to check for bounces
  if (valA == valA2) {                 // make sure we got 2 consistant readings!
    if (valA != buttonStateA) {          // the button state has changed!
      if (valA == LOW) {            // check if the button is pressed
        noteOn(midichan,  switchA, 64);
      }
      else {
        noteOff(midichan, switchA, 0);
      }
    }
    buttonStateA = valA;                 // save the new state in our variable
  } // Switch End

  // Switch B Start
  int valB = digitalRead(switchBPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  int valB2 = digitalRead(switchBPin);   // read the input again to check for bounces
  if (valB == valB2) {                 // make sure we got 2 consistant readings!
    if (valB != buttonStateB) {          // the button state has changed!
      if (valB == LOW) {            // check if the button is pressed
        noteOn(midichan,  switchB, 64);
      }
      else {
        noteOff(midichan, switchB, 0);
      }
    }
    buttonStateB = valB;                 // save the new state in our variable
  } // Switch End

  // Switch C Start
  int valC = digitalRead(switchCPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  int valC2 = digitalRead(switchCPin);   // read the input again to check for bounces
  if (valC == valC2) {                 // make sure we got 2 consistant readings!
    if (valC != buttonStateC) {          // the button state has changed!
      if (valC == LOW) {            // check if the button is pressed
        noteOn(midichan,  switchC, 64);
      }
      else {
        noteOff(midichan, switchC, 0);
      }
    }
    buttonStateC = valC;                 // save the new state in our variable
  } // Switch End

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
        delay(150);
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
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    switchA = bank0A;
    switchB = bank0B;
    switchC = bank0C;
    control = 0x02;
  }

  if(number==1) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    switchA = bank1A;
    switchB = bank1B;
    switchC = bank1C;
    control = 0x02;
  }

  if(number==2) {
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    switchA = bank2A;
    switchB = bank2B;
    switchC = bank2C;
    control = 0x07;
  }

  if(number==3) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    switchA = bank3A;
    switchB = bank3B;
    switchC = bank3C;
    control = 0x07;
  }

  if(number==4) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    switchA = bank4A;
    switchB = bank4B;
    switchC = bank4C;
    control = 0x02;
  }

  if(number==5) {
    digitalWrite(2, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    switchA = bank5A;
    switchB = bank5B;
    switchC = bank5C;
    control = 0x02;
  }

  if(number==6) {
    digitalWrite(2, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    switchA = bank6A;
    switchB = bank6B;
    switchC = bank6C;
    control = 0x07;
  }

  if(number==7) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    switchA = bank7A;
    switchB = bank7B;
    switchC = bank7C;
    control = 0x07;
  }

  if(number==8) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    switchA = bank8A;
    switchB = bank8B;
    switchC = bank8C;
    control = 0x02;
  }

  if(number==9) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    switchA = bank9A;
    switchB = bank9B;
    switchC = bank9C;
    control = 0x07;
  }
}

// I LOVE YOU DREW
void midi_volume(byte channel, byte vol) {
  midiMsg((0xB0 | (channel<<4)), control, vol & 0x7f);
}
// Send a MIDI note-on message.  Like pressing a piano key
void noteOn(byte channel, byte note, byte velocity) {
  midiMsg((0x80 | (channel<<4)), note, velocity);
}

// Send a MIDI note-off message.  Like releasing a piano key
void noteOff(byte channel, byte note, byte velocity) {
  midiMsg((0x80 | (channel<<4)), note, velocity);
}

// Send a general MIDI message
void midiMsg(byte cmd, byte data1, byte data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}
