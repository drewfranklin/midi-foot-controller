/*
 * MIDI Drum Kit
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
#define midichan           1

// general midi drum notes
#define note_record     38
#define note_overdub    39
#define note_mute       42

// define the pins we use
#define switchAPin 7
#define switchBPin 6
#define switchCPin 5
#define ledPin     13  // for midi out status

int valA, valB, valC;                             // variable for reading the pin status
int valA2, valB2, valC2;                          // variable for reading the delayed status
int buttonStateA, buttonStateB, buttonStateC;     // variable to hold the button state

void setup() {
  pinMode(switchAPin, INPUT);
  pinMode(switchBPin, INPUT);
  pinMode(switchCPin, INPUT);

  
  pinMode(ledPin, OUTPUT);
  Serial.begin(31250);   // set MIDI baud rate
  buttonStateA = digitalRead(switchAPin);   // read the initial state
  buttonStateB = digitalRead(switchBPin);   // read the initial state
  buttonStateC = digitalRead(switchCPin);   // read the initial state
}

void loop() {
  // Switch 1 Start
  valA = digitalRead(switchAPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  valA2 = digitalRead(switchAPin);     // read the input again to check for bounces
  if (valA == valA2) {                 // make sure we got 2 consistant readings!
    if (valA != buttonStateA) {          // the button state has changed!
      if (valA == LOW) {            // check if the button is pressed
        noteOn(midichan,  note_record, 64);
      } else {
        noteOff(midichan, note_record, 0); 
      }
    }
    buttonStateA = valA;                 // save the new state in our variable
  } // Switch 1 End
  
  // Switch 2 Start
  valB = digitalRead(switchBPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  valB2 = digitalRead(switchBPin);     // read the input again to check for bounces
  if (valB == valB2) {                 // make sure we got 2 consistant readings!
    if (valB != buttonStateB) {          // the button state has changed!
      if (valB == LOW) {            // check if the button is pressed
        noteOn(midichan,  note_overdub, 64);
      } else {
        noteOff(midichan, note_overdub, 0); 
      }
    }
    buttonStateB = valB;                 // save the new state in our variable
  } // Switch 2 End
  
  // Switch 3 Start
  valC = digitalRead(switchCPin);      // read input value and store it in val
  delay(10);                         // 10 milliseconds is a good amount of time
  valC2 = digitalRead(switchCPin);     // read the input again to check for bounces
  if (valC == valC2) {                 // make sure we got 2 consistant readings!
    if (valC != buttonStateC) {          // the button state has changed!
      if (valC == LOW) {            // check if the button is pressed
        noteOn(midichan,  note_mute, 64);
      } else {
        noteOff(midichan, note_mute, 0); 
      }
    }
    buttonStateC = valC;                 // save the new state in our variable
  } // Switch 3 End
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
  digitalWrite(ledPin,HIGH);  // indicate we're sending MIDI data
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
  digitalWrite(ledPin,LOW);
}
