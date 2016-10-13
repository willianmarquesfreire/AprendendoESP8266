wifi.setmode(wifi.STATION)
wifi.sta.config("TP-LINK_E91ECC","irenevaldirwillian")
print(wifi.sta.getip())

button = 1

gpio.mode(button,gpio.INPUT)


estadoBotao = gpio.read(button)

print("----> Willian: Estado do botão")
print(gpio.read(button))


srv = net.createServer(net.TCP)

html = [[
    <h1>Hello, Willianm. </h1>
]]

srv:listen(80, 
    function(conn)
        conn:on("receive", 
            function(conn, payload)
                print("----> WmfSystem: Termino de Carregamento: Inicio Receive")
                print("-----> CONN")
                print(conn)
                print("-----> PayLOAD")
                print(payload)
                conn:send(html)
                print("----> WmfSystem: Termino de Carregamento: Fim Receive")
            end
        )
        conn:on("sent",
            function(conn, payload)
                print("----> WmfSystem: Termino de Carregamento")
                conn:close()
            end
        )
        
    end
)
