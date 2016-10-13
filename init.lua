wifi.setmode(wifi.STATION)
wifi.sta.config("TP-LINK_E91ECC","irenevaldirwillian")
print(wifi.sta.getip())

led = 2
button = 3

gpio.mode(led,gpio.OUTPUT)
gpio.mode(button, gpio.INT)

function buttonPress(level) 
    if (level == 0) then
        print("----> LED OFF")
        gpio.write(led,gpio.LOW)
    else
        print("----> LED ON")
        gpio.write(led, gpio.HIGH)
    end
end

gpio.trig(button, "both",buttonPress)

print("----> Willian: Estado do botão")
print(gpio.read(button))


srv = net.createServer(net.TCP)

html = [[
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" 
        href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" 
        integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" 
        crossorigin="anonymous">
    </head>
    <body>
        <h1>Hello, Willian. Configure um Pino GPIO</h1>
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                <form action="" method="get">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                       <div class="form-group">
                                            <label>Pin</label>
                                            <input type="number" class="form-control" name="gpio"><br>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                        <div class="form-group">
                                            <label>Mode</label>
                                            <input type="radio" class="form-control" name="mode" value="OUTPUT"> OUTPUT
                                            <input type="radio" class="form-control" name="mode" value="INT"> INT<br>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                        <div class="form-group">
                                            <label>Action</label>
                                            <input type="radio" class="form-control" name="action" value="HIGH"> HIGH
                                            <input type="radio" class="form-control" name="action" value="LOW"> LOW<br>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                       <input type="hidden" name="configurableGPIO" value="sim">
                                       <button type="submit" class="btn btn-default">Send</button>
                                    </div>
                            </div>
                        </div>
                    </div>
                </form>
                </div>
            </div>
        </div>
    </body>
</html>
    
]]

srv:listen(80, 
    function(conn)
        conn:on("receive", 
            function(client, request)
                local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
                if(method == nil)then
                    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
                end
                local _GET = {}
                if (vars ~= nil)then
                    for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                        _GET[k] = v
                    end
                end
                local _on,_off = "",""
                if(_GET.button == "LEDON")then
                    gpio.write(led, gpio.HIGH);
                elseif(_GET.button == "LEDOFF")then
                    gpio.write(led, gpio.LOW);
                elseif(_GET.configurableGPIO == "sim") then
                    print("Entrou")
                    if (_GET.mode == "INT") then
                        gpio.mode(tonumber(_GET.gpio), gpio.INT)
                        print("INT")
                    else
                        gpio.mode(tonumber(_GET.gpio), gpio.OUTPUT)
                        print("OUTPUT")
                    end
                    if (_GET.action == "LOW") then
                        gpio.write(tonumber(_GET.gpio), gpio.LOW)
                        print("LOW")
                    else
                        gpio.write(tonumber(_GET.gpio), gpio.HIGH)
                        print("HIGH")
                    end
                end
                client:send(html);
                client:close();
                collectgarbage();
                
            end
        )
        
        
    end
)
