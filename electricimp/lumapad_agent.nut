//****************************************************************************
//
// Simple agent code. We just take a value set via 'http get' against this
// agent's specific URL and pass that value down to the eimp to interpret.
//

server.log("Hello from the agent");

// http.agenturl() is the URL that will let external entities interact with
// this agent (and thus the electric imp device attached to this agent.)
//
server.log("Set brightness of panel: " + http.agenturl() + "?state=<float between 0 and 1>");
server.log("Pulse between both LED channels: " + http.agenturl() + "?state=off");

//****************************************************************************
//
// Send the value we get in the HTTP request down to the device to deal with.
//
// XXX We should really sanity check the values we get called with (here as
//     well as in the device code.)
//
function httpHandler(request, response) {
    if ("state" in request.query) {
        local state = request.query.state;
        device.send("chan0_set", state);
    }
    response.send(200, "OK");
}
http.onrequest(httpHandler);
