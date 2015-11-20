l = require "lssock"

local server = assert(l.new())
assert(server:bind("*", 8899))
assert(server:listen())

local peers = {}
while l.sleep(10) do
	local peer = server:accept()
	if peer then
		table.insert(peers, peer)
	end
	local intrest = l.select(0, peers)
	if #intrest > 0 then
		print("==============")
		for idx, peer in pairs(intrest) do
			if peer:isconnect() then
				print(idx, peer:getpeername())
				peer:read()
			end
		end
	end
end
