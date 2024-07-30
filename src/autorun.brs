' 24/02/24 Test Standalone version - Debug Generic - RLB

Sub Main()

	print ""
	print "Version v1.3"
	print ""

	m.msgPort = CreateObject("roMessagePort")
	b = CreateObject("roByteArray")
	b.FromHexString("ffffffff")
	color_spec% = (255*256*256*256) + (b[1]*256*256) + (b[2]*256) + b[3]
	' videoMode = CreateObject("roVideoMode")
	' videoMode.SetBackgroundColor(color_spec%)
	'videomode.Setmode("3840x2160x25p:gfxmemlarge")
	'videomode.Setmode("3840x2160x60p:fullres")
	'videomode.Setmode("1920x1080x60p")
	videoMode = CreateObject("roVideoMode")
	videoMode.SetBackgroundColor(color_spec%)
	SystemLog = CreateObject("roSystemLog")

	di = CreateObject("roDeviceInfo")
	model = di.GetModel()
	print "Model: "; model
	serialNumber = di.GetDeviceUniqueId()
	outputNumber = Mid(model, 3, 1)
	Is_Series_5 = Right(model, 1) = "5"
	shortSerialNumber = Right(serialNumber, 4)
	NewPlayerName = model + "-" + shortSerialNumber

	''' Set Video Mode for Series 5
	Series5_HDMI1_Videomode = "1920x1080x60p"
	''' Set Video Mode for Series 3 and 4 and earlier
	OtherSeriesVideomode = "1920x1080x60p"

	if Is_Series_5 then	
		sm = videoMode.GetScreenModes()

		sm[0].name = "HDMI-1"
		'sm[0].video_mode = "Modeline 1080x1920_50.00  144.50  1080 1160 1272 1464  1920 1923 1933 1978 -hsync +vsync"
		'sm[0].video_mode = "Modeline 3840x2160x30p 297.00 3840 4016 4104 4400  2160 2168 2178 2250  +hsync -vsync"
		sm[0].video_mode = Series5_HDMI1_Videomode
		sm[0].transform = "normal"
		'sm[0].transform = "90"
		sm[0].display_x = 0
		sm[0].display_y = 0
		sm[0].enabled = true
  
		' Safeguard for models more than 1 HDMI outputs
		if (sm[1] <> invalid and Instr(0, sm[1].name, "HDMI") <> 0) then
			sm[1].name = "HDMI-2"
			'sm[1].video_mode ="Modeline 1080x1920_50.00  144.50  1080 1160 1272 1464  1920 1923 1933 1978 -hsync +vsync"
			'sm[1].video_mode = "Modeline 3840x2160x30p 297.00 3840 4016 4104 4400  2160 2168 2178 2250  +hsync -vsync"
			sm[1].video_mode = ""
			sm[1].transform = "normal"
			sm[1].display_x = 1920
			sm[1].display_y = 0
			sm[1].enabled = false
		end if

		if (sm[2] <> invalid and Instr(0, sm[1].name, "HDMI") <> 0) then
			sm[2].name = "HDMI-3"
			'sm[1].video_mode ="Modeline 1080x1920_50.00  144.50  1080 1160 1272 1464  1920 1923 1933 1978 -hsync +vsync"
			'sm[1].video_mode = "Modeline 3840x2160x30p 297.00 3840 4016 4104 4400  2160 2168 2178 2250  +hsync -vsync"
			sm[2].video_mode = ""
			sm[2].transform = "normal"
			sm[2].display_x = 0
			sm[2].display_y = 0
			sm[2].enabled = false
		end if

		if (sm[3] <> invalid and Instr(0, sm[1].name, "HDMI") <> 0) then
			sm[3].name = "HDMI-4"
			'sm[1].video_mode ="Modeline 1080x1920_50.00  144.50  1080 1160 1272 1464  1920 1923 1933 1978 -hsync +vsync"
			'sm[1].video_mode = "Modeline 3840x2160x30p 297.00 3840 4016 4104 4400  2160 2168 2178 2250  +hsync -vsync"
			sm[3].video_mode = ""
			sm[3].transform = "normal"
			sm[3].display_x = 0
			sm[3].display_y = 0
			sm[3].enabled = false
		end if

		videoMode.SetScreenModes(sm)
		reportedVideoMode = videoMode.GetScreenModes()[0].video_mode
		print "reportedVideoMode: "; reportedVideoMode
		SystemLog.sendline("@@@ reportedVideoMode: " + reportedVideoMode)
	else
		videoMode.SetMode(OtherSeriesVideomode)
	end if	

	graphicPlaneWidth = videoMode.GetResX()
	graphicPlaneHeight = videoMode.GetResY()

	print "graphicPlaneWidth: "; graphicPlaneWidth
	print "graphicPlaneHeight: "; graphicPlaneHeight

	'''''''''''''''''''''''''''''''''''''''

	r1CoordinateX = 0
	r1CoordinateY = 0

	r2CoordinateX = 0
	r2CoordinateY = 0

	m.r1 = createobject("rorectangle",r1CoordinateX,r1CoordinateY,graphicPlaneWidth,graphicPlaneHeight)
	'm.r2 = createobject("rorectangle",r2CoordinateX,r2CoordinateY,graphicPlaneWidth,graphicPlaneHeight)

	'''''''''''''''''''''''''''''''''''''''
	SystemLog.sendline("@@@ Rectangle 1 param: " + str(r1CoordinateX) + " , " +  str(r1CoordinateY) + " , " + str(graphicPlaneWidth) + " , " +  str(graphicPlaneHeight))
	'SystemLog.sendline("@@@ Rectangle 2 param: " + str(r2CoordinateX) + " , " +  str(r2CoordinateY) + " , " + str(graphicPlaneWidth) + " , " +  str(graphicPlaneHeight))
	SystemLog.sendline("@@@ Graphics Plane width: " + str(videoMode.GetResX()) + " - Graphics Plane height: " + str(videoMode.GetResY()))
	SystemLog.sendline("@@@ Video Plane width: " + str(videoMode.GetVideoResX()) + " - Video Plane height: " + str(videoMode.GetVideoResY()))
	'stop

	bs_media_player_val = "1"
	'bs_media_player_val = "0"
	widget_type_val = "default"
	'widget_type_val = "chromium110"
	enable_web_inspector = "1"
	'enable_web_inspector = "0"
	telnet_port = "23"
	bs_media_player = false
	widget_type_val_set = false
	enable_web_inspector_set = false
	debug_set = false
	telnet_port_set = false
	dwsRebootRequired = false
	NewPlayerName_set = false

	if type(HTMLRegistrySection) <> "roRegistrySection" then 
		HTMLRegistrySection = CreateObject("roRegistrySection", "html")
	end if

	if HTMLRegistrySection.read("use-brightsign-media-player") <> "1" or HTMLRegistrySection.read("use-brightsign-media-player") = invalid then
		HTMLRegistrySection.write("use-brightsign-media-player", "1")
		HTMLRegistrySection.flush()

		print "use-brightsign-media-player key set to "; bs_media_player_val 
		bs_media_player = true
	else 
		print "use-brightsign-media-player registry Already set to "; bs_media_player_val
	end if 


	if HTMLRegistrySection.read("widget_type") <> widget_type_val or HTMLRegistrySection.read("widget_type") = invalid then
		HTMLRegistrySection.write("widget_type", widget_type_val)
		HTMLRegistrySection.flush()

		print "widget_type registry key set to "; widget_type_val
		widget_type_val_set = true
	else 
		print "widget_type registry Already set to "; widget_type_val
	end if 


	if HTMLRegistrySection.read("enable_web_inspector") <> enable_web_inspector or HTMLRegistrySection.read("enable_web_inspector") = invalid then
		HTMLRegistrySection.write("enable_web_inspector", enable_web_inspector)
		HTMLRegistrySection.flush()

		print "enable_web_inspector registry key set to "; enable_web_inspector
		enable_web_inspector_set = true
	else 
		print "enable_web_inspector registry Already set to "; enable_web_inspector
	end if

	if type(BSRegistrySection) <> "roRegistrySection" then 
		BSRegistrySection = CreateObject("roRegistrySection", "brightscript")
	end if

	if BSRegistrySection.read("debug") <> "1" or BSRegistrySection.read("debug") = invalid then
		BSRegistrySection.write("debug", "1")
		BSRegistrySection.flush()
		print "debug key set to 1"
		debug_set = true
	else 
		print "debug key Already set to 1"
	end if

	if type(NetRegistrySection) <> "roRegistrySection" then 
		NetRegistrySection = CreateObject("roRegistrySection", "networking")
	end if

	if NetRegistrySection.read("telnet") <> telnet_port or NetRegistrySection.read("telnet") = invalid then
		NetRegistrySection.write("telnet", telnet_port)
		NetRegistrySection.flush()
		print "telnet_port key set to "; telnet_port
		telnet_port_set = true
	else 
		print "telnet_port key Already set to "; telnet_port
	end if


	if NetRegistrySection.read("un") <> NewPlayerName or NetRegistrySection.read("un") = invalid then
		NetRegistrySection.write("un", NewPlayerName)
		NetRegistrySection.flush()
		print "un key set to "; NewPlayerName
		NewPlayerName_set = true
	else 
		print "un key Already set to "; NewPlayerName
		print ""
		print "Player Name: "; NewPlayerName
		print ""
	end if

	' Remove DWS Password
	dwsp = NetRegistrySection.read("dwsp")
	dwsAA = CreateObject("roAssociativeArray")
	'dwsAA["port"] = "8080"	
	'dwsAA["password"] = m.obfuscatedPass$
	dwsAA["port"] = "80"
	dwsAA["password"] = ""

	nc = CreateObject("roNetworkConfiguration", 0)
	if type(nc) = "roNetworkConfiguration"
		dwsRebootRequired = nc.SetupDWS(dwsAA)
		nc.Apply()
		
		print "@@@@ DWS is Setup without a password @@@@"

		NetRegistrySection.write("dwsp", "")
		NetRegistrySection.flush()
	end if


	if bs_media_player = true or widget_type_val_set = true or debug_set = true or telnet_port_set = true or dwsRebootRequired = true or NewPlayerName_set = true then
		print "Rebooting system..."
		RebootSystem()
	end if
	
	m.sTime = createObject("roSystemTime")
	gpioPort = CreateObject("roControlPort", "BrightSign")
	gpioPort.SetPort(m.msgPort)
	m.SystemLog = CreateObject("roSystemLog")	
	m.PluginInitHTMLWidgetStatic = PluginInitHTMLWidgetStatic
	m.InitNodeJS = InitNodeJS
	'm.siteURL = "file:///index-autoplay.html"
	playerIP =	""

	'nc.GetCurrentConfig().ip4_address
	playerIP = nc.GetCurrentConfig().ip4_address
	m.siteURL = "http://"+ playerIP + ":3000/public"
	
'''''''''''''''''''''''''''''''''''''''''''''''''''' LIVE TELNET Instructions ''''''''''''''''''''''''''''''''''''''''''''''''''''
print ""
print " # INSTRUCTIONS For Mac - Telnet Output" 
print ""
print " # COPY & PASTE LINE IN VS CODE TERMINAL :% nvm use v14.17.6 && npm install && export DEVICE_NAME=" + NewPlayerName +  " && bsc addplayer " + NewPlayerName +  " " + playerIP
print ""

'''''''''''''''''''''''''''''''''''''''''''''''''''' LIVE TELNET Instructions ''''''''''''''''''''''''''''''''''''''''''''''''''''
	StartInitNodeJSTimer()
	StartInitHTMLWidgetTimer()

	while true
	    
		msg = wait(0, m.msgPort)
		print "type of msgPort is ";type(msg)
	
		if type(msg) = "roTimerEvent" then	
			timerIdentity = msg.GetSourceIdentity()
			'print "Timer msgPort Received " + stri(timerIdentity)
			if type (m.InitNodeJSTimer) = "roTimer" then 
				if m.InitNodeJSTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.InitNodeJS()
				end if
			end if	
			if type (m.InitHTMLWidgetTimer) = "roTimer" then 
				if m.InitHTMLWidgetTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.PluginInitHTMLWidgetStatic()
				end if
			end if
		else if type(msg) = "roNodeJsEvent" then
			print " @@@ roNodeJsEvent @@@ "
			print msg.GetData()						
		else if type(msg) = "roHtmlWidgetEvent" then
			eventData = msg.GetData()
			if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
				Print "roHtmlWidgetEvent = " + eventData.reason
			end if	
		else if type(msg) = "roControlDown" then
			button = msg.GetInt()
			if button = 12 then 
				print " @@@ GPIO 12 pressed @@@  "
				stop
			end if			
		end if				
	end while
End Sub



Function StartInitHTMLWidgetTimer()
	
	print " Set Timer to load HTMLWidget..."
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(2)
	m.InitHTMLWidgetTimer = CreateObject("roTimer")
	m.InitHTMLWidgetTimer.SetPort(m.msgPort)
	m.InitHTMLWidgetTimer.SetDateTime(newTimeout)
	ok = m.InitHTMLWidgetTimer.Start()
End Function


Function StartInitNodeJSTimer()
	
	print " Set StartInitNodeJSTimer Timer..."
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(1)
	m.InitNodeJSTimer = CreateObject("roTimer")
	m.InitNodeJSTimer.SetPort(m.msgPort)
	m.InitNodeJSTimer.SetDateTime(newTimeout)
	ok = m.InitNodeJSTimer.Start()

End Function


Function PluginInitHTMLWidgetStatic()

	'm.PluginRect = CreateObject("roRectangle", 0,0,1920,1080)
	m.PluginRect =  m.r1
	'filepath$ = "Login.js"
	
	is = {
		port: 2999
	}
	m.config = {
		nodejs_enabled: true,
		javascript_injection: { 
		   document_creation: [], 
			document_ready: [],
			deferred: [] 
			'deferred: [{source: filepath$ }]
		},
		javascript_enabled: true,
		port: m.msgPort,
		inspector_server: is,
		brightsign_js_objects_enabled: true,
		url: m.siteURL,
		mouse_enabled: true,
		' storage_quota: "20000000000",
		' storage_path: "sd:/CacheFolder",
		'hwz ON required for smooth video playback on Series 4
		hwz_default: "on",
		security_params: {websecurity: false}
		'transform: "rot90" 
	}
	
	m.PluginHTMLWidget = CreateObject("roHtmlWidget", m.PluginRect, m.config)
	m.PluginHTMLWidget.Show()
End Function



Function InitNodeJS()

	'm.node_js = CreateObject("roNodeJs", "rl_main.js", {message_port: m.msgPort, arguments: []}) ' no inspector loaded
	m.node_js = CreateObject("roNodeJs", "sd:/nodeApp/bundle.js", {message_port: m.msgPort, node_arguments: ["--inspect=0.0.0.0:3001"]}) 'just for loading the inspector
	'm.node_js = CreateObject("roNodeJs", "rl_main.js", {message_port: m.msgPort, node_arguments: ["--inspect-brk=0.0.0.0:2999"]}) 'stops at breakpoints

	if type(m.node_js)<>"roNodeJs" then 
        print " @@@ Error: failed to create roNodeJs  @@@"
	else
		print " @@@ roNodeJs successfully created  @@@"
	end if
End Function