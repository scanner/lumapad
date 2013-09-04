// NOTE: Just a place holder for the arduino code to let the electric
//       imp control the lumapad.
//

#define LED_CHAN1A  10 // PD6-AIN0-OC0A
#define LED_CHAN1B  14 // PB2(SS-OC1B)
#define LED_CHAN1C  1  // PD3(INT1-OC2B)
#define LED_CHAN2A  15 // PB3(MOSI-OC2A)
#define LED_CHAN2B  9  // PD5(T1-OC0B)
#define LED_CHAN2C  13 // PB1(OC1A)

#define FAN        12 // PB0
#define THERMISTOR 19 // ADC6 is the thermistor

void setup() {
  // Make all of the pins tied to the led channel's be input so they will be
  // tied high and let the eimp control this.
  //
  pinMode(LED_CHAN1A, INPUT);
  pinMode(LED_CHAN1B, INPUT);
  pinMode(LED_CHAN1C, INPUT);
  pinMode(LED_CHAN2A, INPUT);
  pinMode(LED_CHAN2B, INPUT);
  pinMode(LED_CHAN2C, INPUT);

  // Configure the fan as an output and turn it on.
  //
  pinMode(FAN, OUTPUT);
  digitalWrite(FAN, HIGH);

  // Set the thermistor as an input.
  //
  pinMode(THERMISTOR, INPUT);
}

int therm_temp;

void loop() {
  // Read the thermistor value and then do something with the fan based on that
  // then sleep for a 1/10th of a second before doing it again.
  //
  therm_temp = analogRead(THERMISTOR);
  delay(500);

}
