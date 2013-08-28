// agent code:
server.log("Hello from the agent");
server.log("Set brightness of panel: " + http.agenturl() + "?state=<float between 0 and 1>");

function httpHandler(request, response) {
    if ("state" in request.query) {
        local state = request.query.state;
        device.send("chan0_set", state);
    }
    response.send(200, "OK");
}
http.onrequest(httpHandler);
