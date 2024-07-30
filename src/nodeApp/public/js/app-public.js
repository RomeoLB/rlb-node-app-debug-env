// public/app.js

document.addEventListener('DOMContentLoaded', () => {

    console.log('Client-side JavaScript is running v1.3');

    const messageElement = document.getElementById('message');
    const ws = new WebSocket(`ws://${window.location.host}`);

    //https://brightsign.atlassian.net/wiki/spaces/DOC/pages/420217548/networkstatus#NetworkStatusIpAddress
    const NetworkStatus = require("@brightsign/networkstatus");
    let networkStatus = new NetworkStatus();
    var video = document.getElementById('deal_video_content');
    var videoDuration = 0;
    var playcounter = 0;
    var playerIP = "";
    

    networkStatus.getInterfaceStatus("eth0")
    .then(function(data) {
        console.log("***General Interface Data***");
        console.log(JSON.stringify(data));
        console.log(data);
        playerIP = data.ipAddressList[0].address;

        console.log("player IP Address: ",playerIP)
        var message = "Access player via Telnet or via a web browser on IP: " + playerIP;
        document.getElementById("ip-address").innerText = "INFO: " + message;
    })
    .catch(function(data) {
            console.log(JSON.stringify(data));
    });
    
    ws.onmessage = (event) => {
        const data = JSON.parse(event.data);
        //messageElement.innerText = data.message;
        console.log("UDP message: ",data.message);
        if(data.message == "red") {
            video.src = "media/vid1.mp4";
            //video.play();
            
        }else if(data.message == "green") {
            video.src = "media/vid2.mp4";
            //video.play();
        }
    };    
    
    ws.onopen = () => {
        console.log('WebSocket connection established');
    };
    
    ws.onerror = (error) => {
        console.error('WebSocket error:', error);
        //messageElement.innerText = 'Failed to load message';
    };

    ws.onclose = () => {
        console.log('WebSocket connection closed');
    }; 

    video.addEventListener('loadedmetadata', function () {
        videoDuration = video.duration;
        console.log('videoDuration: ' + videoDuration + ' name: ' + video.src);
    });

    video.addEventListener('ended', function () {
        playcounter++;
        console.log('times video has played: ', playcounter);
        video.src = "media/vid1.mp4";
        video.play();
    });


});