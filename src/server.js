// server.js
console.log('Server is running version 1.0.3');
const NetworkStatus = require("@brightsign/networkstatus");
let networkStatus = new NetworkStatus();
const express = require('express');
const path = require('path');
const dgram = require('dgram');
const { Server } = require('ws');
const bodyParser = require('body-parser');
const favicon = require('serve-favicon');

const app = express();
const udpServer = dgram.createSocket('udp4');
const udpClient = dgram.createSocket('udp4');
const PORT = process.env.PORT || 3000;
const UDP_PORT = 5000;
let UDP_HOST;

networkStatus.getInterfaceStatus("eth0")
.then(function(data) {
    console.log("***General Interface Data***");
    console.log(JSON.stringify(data));
    console.log(data);
    playerIP = data.ipAddressList[0].address;

    console.log("player IP Address: ",playerIP)

    UDP_HOST = playerIP;
})
.catch(function(data) {
        console.log(JSON.stringify(data));
});

let udpMessage = 'No UDP message received yet';

app.use(bodyParser.json());

// Serve static files from the public directory
//app.use(express.static(path.join(__dirname, 'public')));

// Serve static files for Site 1
app.use('/public', express.static(path.join(__dirname, 'public')));

// Serve static files for Site 2
app.use('/control', express.static(path.join(__dirname, 'control')));

// Set the path to your favicon.ico file
app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.post('/send-message', (req, res) => {
    const { message } = req.body;
    const messageBuffer = Buffer.from(message);

    udpClient.send(messageBuffer, UDP_PORT, UDP_HOST, (err) => {
        if (err) {
            console.error(`UDP message send error: ${err}`);
            res.status(500).json({ status: 'error', message: err.message });
        } else {
            console.log(`UDP message sent: ${message}`);
            res.status(200).json({ status: 'success', message: 'Message sent successfully' });
        }
    });
});

// WebSocket server setup
const server = app.listen(PORT, () => {
    console.log(`HTTP server is running on port ${PORT}`);
});

const wss = new Server({ server });

wss.on('connection', (ws) => {
    console.log('WebSocket connection established');
    ws.send(JSON.stringify({ message: udpMessage }));

    udpServer.on('message', (msg, rinfo) => {
        console.log(`UDP message received from ${rinfo.address}:${rinfo.port} - ${msg}`);
        udpMessage = msg.toString();
        ws.send(JSON.stringify({ message: udpMessage }));
    });
});

// Start the UDP server
udpServer.bind(UDP_PORT, () => {
    console.log(`UDP server is listening on port ${UDP_PORT}`);
});