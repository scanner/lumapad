// Device code for an electric imp to control a lumapad.
//
imp.configure("AS LumaPad 01", [], []);
server.log("Hello from the lumapad");

led_chan2 <- hardware.pin9;
led_chan1 <- hardware.pin8;
imp_control <- hardware.pin1;

// To tell the lumapad arduino that we want the eimp to control the led's we set pin1 high.
//
imp_control.configure(DIGITAL_OUT);
imp_control.write(1);

// For just "off" / "on" control of the two LED channels we bring each output
// either 'high' or 'low'
//
// led_chan1.configure(DIGITAL_OUT);
// led_chan1.write(0);
// led_chan2.configure(DIGITAL_OUT);
// led_chan2.write(0);

led_chan1.configure(PWM_OUT, 1.0/1000.0, 1.0);
led_chan2.configure(PWM_OUT, 1.0/1000.0, 1.0);

chan1_bright <- 0.0;
chan2_bright <- 0.0;
imp_control <- "off";
going_up <- 1;

//****************************************************************************
//
// Given a floating point value between 0 and 1 (inclusive) set both LED
// channels to that brightness (via PWM)
//
// Typically called via the cloud based agent associated with this device.
//
function chan0_set(value) {

    if (value == "off") {
        // If we get called with the value of 'off' this calls the loop that
        // will cycle the two channels up and down
        //
        imp_control = "off";
        server.log("Turning http control off");
        cycle_leds_up_and_down();
        return
    } else {
        // Any other value turns off cycling of the up and down loop letting us
        // set the brightness to exactly what was specified in the call from
        // the agent.
        //
        server.log("Turning http control on");
        imp_control = "on";
    }

    local v = 0.0;
    try {
        v = value.tofloat();
    } catch (e) {
        server.log("Error converting " + value);
    }
    if ( v > 1.0) {
        v = 1.0;
    }
    if ( v < 0) {
        v = 0.0;
    }
    // write a floating point number between 0.0 and 1.0, where 1.0 = 100% duty
    // cycle
    //
    server.log(format("Setting channel to %f",v));
    led_chan1.write(v);
    led_chan2.write(v);
}

//****************************************************************************
//
// basically a test loop that does a simplistic linear cycle of both LED
// channels up and down - but does them 90 degrees out of phase with each
// other (so you can see that both channels are working and controllable)
//
// keeps running until the global variable "imp_control" is not set to the
// string "on"
//
function cycle_leds_up_and_down() {
    if (imp_control == "on") {
        return;
    }
    if (going_up == 1) {
        chan1_bright += 0.01;
        if (chan1_bright > 1.0) {
            going_up = 0;
            chan1_bright = 1.0;
        }
    } else {
        chan1_bright -= 0.01;
        if (chan1_bright < 0.0) {
            chan1_bright = 0.0;
            going_up = 1;
        }
    }
    led_chan1.write(chan1_bright);
    // led_chan2.write(1.0 - chan1_bright);
    led_chan2.write(chan1_bright);

    // Go to sleep and wake up a 20th of a second lter. This is going to bump
    // the brightness (up or down) by 10% every 20th of a second.
    //
    imp.wakeup(0.05, cycle_leds_up_and_down);
}

//************
//
// Configure the 'chan0_set' function to be tied to the 'chan0_set' message
// from the agent.
//
agent.on("chan0_set", chan0_set);

// Turn both channels on to start. When you turn it on you want the lights on, right?
//
led_chan1.write(1.0);
led_chan2.write(1.0);

// Now we wait for commands to tell us to do various things.
