local sock = require "lssock"
local port = 10240
server = false
peersMap = {}

function Update()
	assert(server)
	for peer, _ in pairs(peersMap) do
		peer:read()
		if not peer:isconnect() then
			peersMap[peer] = nil
			print("peer disconnect")
		end
	end
	while true do
		local peer = server:accept()
		if not peer then
			break
		end
		peersMap[peer] = true
	end
end

function DispatchMsg(msg)
	for peer, _ in pairs(peersMap) do
		if peer:isconnect() then
			peer:write(msg)
		end
	end
end

function Init()
	server = sock.new()
	server:bind("0.0.0.0", port)
	server:listen()
end

function test()
	Init()
	local i = 0
	while sock.sleep(10) do
		Update()
		if i % 100 == 0 then
			i = 0
			DispatchMsg("hello world\n")
		end
		i = i + 1
	end
end

test()
