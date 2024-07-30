const { Telnet } = require('telnet-client');
require('dotenv').config();
let connection = new Telnet();
const host = process.env.BSHOST;
console.log('host:', host);


let params = {
    host: host,
    port: 23, // default Telnet port
    shellPrompt: '/ # ', // or whatever your shell prompt is
    timeout: 4000,
    negotiationMandatory: false,
    debug: true // enable debug messages if you need to troubleshoot
};

async function sendCommands() {
    try {
        await connection.connect(params);
        console.log('Connected to the server.');

        // Delay to ensure the connection is fully established
        setTimeout(async () => {
            try {
                const ctrlCRes = await connection.send('\x03'); // sending Ctrl-C
                console.log('Ctrl-C sent successfully:', ctrlCRes);

                // Wait 1 second before sending the "exit" command
                setTimeout(async () => {
                    try {
                        const exitRes = await connection.send('exit');
                        console.log('Exit command sent successfully:', exitRes);

                        // Wait 1 second before sending the "script autorun.brs" command
                        setTimeout(async () => {
                            try {
                                const scriptRes = await connection.send('script autorun.brs');
                                console.log('Script command sent successfully:', scriptRes);
                            } catch (err) {
                                console.error('Error sending script command:', err);
                            } finally {
                                connection.end();
                                console.log('Connection closed.');
                            }
                        }, 1000);
                    } catch (err) {
                        console.error('Error sending exit command:', err);
                    }
                }, 1000);
            } catch (err) {
                console.error('Error sending Ctrl-C:', err);
            }
        }, 1000); // Wait 1 second before sending the Ctrl-C command
    } catch (err) {
        console.error('Connection error:', err);
    }
}

connection.on('timeout', function() {
    console.log('Socket timeout!');
    connection.end();
});

connection.on('close', function() {
    console.log('Connection closed.');
});

sendCommands();
