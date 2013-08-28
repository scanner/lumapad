// Device code for an electric imp to control a lumapad.
//
imp.configure("AS LumaPad 01", [], []);
server.log("Hello from the lumapad");

led_chan2 <- hardware.pin9;
led_chan1 <- hardware.pin8;

// led_chan1.configure(DIGITAL_OUT);
// led_chan1.write(0); // working
// led_chan2.configure(DIGITAL_OUT);
// led_chan2.write(0);

led_chan1.configure(PWM_OUT, 1.0/500.0, 1.0);
led_chan2.configure(PWM_OUT, 1.0/500.0, 1.0);

chan1_bright <- 0.0;
chan2_bright <- 0.0;
imp_control <- "off";
going_up <- 1;

function chan0_set(value) {
    if (value == "off") {
        imp_control = "off";
        server.log("Turning http control off");
        loop();
        return
    } else {
        server.log("Turning http control on");
        imp_control = "on";
    }
    local v = value.tofloat();
    if ( v > 1.0) {
        v = 1.0;
    }
    if ( v < 0) {
        v = 0.0;
    }
    // write a floating point number between 0.0 and 1.0, where 1.0 = 100% duty cycle
    server.log(format("Setting channel to %f",v));
    led_chan1.write(v);
    led_chan2.write(v);
}

function loop() {
    if (imp_control == "on") {
        return;
    }
    if (going_up == 1) {
        chan1_bright += 0.1;
        if (chan1_bright > 1.0) {
            going_up = 0;
            chan1_bright = 1.0;
        }
    } else {
        chan1_bright -= 0.1;
        if (chan1_bright < 0.0) {
            chan1_bright = 0.0;
            going_up = 1;
        }
    }
    led_chan1.write(chan1_bright);
    led_chan2.write(1.0 - chan1_bright);
    imp.wakeup(0.05, loop);
}
agent.on("chan0_set", chan0_set);
led_chan1.write(0.0);
led_chan2.write(0.0);
loop();

