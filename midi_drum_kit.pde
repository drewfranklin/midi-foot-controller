/*
 * MIDI Drum Kit
 * -------------
 * Convert Arduino to a MIDI controller using various inputs and
 * the serial port as a MIDI output.
 *
 * This sketch is set up to send General MIDI (GM) drum notes 
 * on MIDI channel 1, but it can be easily reconfigured for other
 * notes and channels
 *
 * It uses switch inputs to send MIDI notes of a fixed velocity with
 * note on time determined by duration of keypress and it uses
 * piezo buzzer elements as inputs to send MIDI notes of a varying velocity
 * & duration, depending on forced of impulse imparted to piezo sensor.
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
#define drumchan           1

// general midi drum notes
#define note_record     38
#define note_overdub    39
#define note_mute       42

// define the pins we use
#define switchAPin 7
#define switchBPin 6
#define switchCPin 5
#define ledPin     13  // for midi out status

int switchAState = LOW;
int switchBState = LOW;
int switchCState = LOW;
int currentSwitchState = LOW;

int val,t;

void setup() {
  pinMode(switchAPin, INPUT);
  pinMode(switchBPin, INPUT);
  pinMode(switchCPin, INPUT);
  digitalWrite(switchAPin, HIGH);  // turn on internal pullup
  digitalWrite(switchBPin, HIGH);  // turn on internal pullup
  digitalWrite(switchCPin, HIGH);  // turn on internal pullup

  pinMode(ledPin, OUTPUT);
  Serial.begin(31250);   // set MIDI baud rate
}

void loop() {
  // deal with switchA
  currentSwitchState = digitalRead(switchAPin);
  if( currentSwitchState == LOW && switchAState == HIGH ) // push
    noteOn(drumchan,  note_record, 64);
  if( currentSwitchState == HIGH && switchAState == LOW ) // release
    noteOff(drumchan, note_record, 0);
  switchAState = currentSwitchState;

  // deal with switchB
  currentSwitchState = digitalRead(switchBPin);
  if( currentSwitchState == LOW && switchBState == HIGH ) // push
    noteOn(drumchan,  note_overdub, 64);
  if( currentSwitchState == HIGH && switchBState == LOW ) // release
    noteOff(drumchan, note_overdub, 0);
  switchBState = currentSwitchState;

  // deal with switchC
  currentSwitchState = digitalRead(switchCPin);
  if( currentSwitchState == LOW && switchCState == HIGH ) // push
    noteOn(drumchan,  note_mute, 64);
  if( currentSwitchState == HIGH && switchCState == LOW ) // release
    noteOff(drumchan, note_mute, 0);
  switchCState = currentSwitchState;
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
