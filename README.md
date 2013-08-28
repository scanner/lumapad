lumapad
=======

Arduino and Electric Imp code for controlling the LumaPad 8000s

This contains both an arduino project and electric imp code. This is
necessary to properly enable the electric imp to control the lumapad
directly (have to make sure the arduino sets the right inputs to high
impedance, and keep basic code for knowing when to turn the big fan on
to prevent overheating.)

NOTE: This uses the electric imp beta IDE. This is instead of the
      planner. Instead of code for the device only you have the pair
      for every imp of what code is on the device and what code is
      running as an agent in the cloud.

      Communications with the imp are through the agent.
