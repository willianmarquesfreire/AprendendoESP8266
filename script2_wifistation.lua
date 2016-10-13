-- Conexao na rede Wifi
wifi.setmode(wifi.STATION)
wifi.sta.config("TP-LINK_E91ECC","irenevaldirwillian")
print(wifi.sta.getip())
-- Definicoes do pino do led
led1 = 1
gpio.mode(led1, gpio.OUTPUT)
-- Definicoes do Web Server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
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
        buf = [[
        <h1>
            <u>WmfSystem</u>
        </h1>
        <h2>
            <i>ESP8266 Web Server</i>
        </h2>
        <p>
            <a href=\"?pin=LIGA1\">
                <button>
                    <b>LED 1 LIG</b>
                </button>
            </a> 
            <br/><br/>
            <a href=\"?pin=DESLIGA1\">
                <button>
                    <b>LED 1 DES</b>
                </button>
            </a>
        </p>
       ]]

       variavel="Willian"
       print(variavel)
                local _on,_off = "",""
        if(_GET.pin == "LIGA1")then
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "DESLIGA1")then
              gpio.write(led1, gpio.LOW);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
