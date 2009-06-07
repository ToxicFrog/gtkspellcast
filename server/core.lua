-- this is the entry point for the server module

-- basic flow of control:
--  initialized with game information
--  create listen socket
--  register timer callback to accept incoming connections

server = {}

local sock,acceptor

function server.host(game)
    ui.message("[server] hosting on port %d", game.port)

    sock = socket.bind('*', game.port)
    sock:settimeout(0)
    
    function acceptor()
        local client = sock:accept()
        
        if client then
            ui.message("[server] client connected: %s", client:getpeername())
            
            local function clienthandler(evt)
                ui.message("[server] event: %s", evt.event)
                evt.event = evt.event.."::server"
                event.send(client, evt)
            end
            
            event.register(client, clienthandler)
        end
    end

    event.register(acceptor)
end

function server.shutdown()
    ui.message("[server] shutting down")
    event.unregister(acceptor)
    sock:close()
    sock,acceptor = nil
end

