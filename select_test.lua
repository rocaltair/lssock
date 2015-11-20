l = require "lssock"

local server = assert(l.new())
assert(server:bind("*", 8899))
assert(server:listen())

local peers = {}
while l.sleep(10) do
	local peer = server:accept() 		-- no wait
	if peer then
		table.insert(peers, peer)
	end
	local interests = l.select(0, peers)	-- arg #1, wait time as ms
	if #interests > 0 then
		print("==============")
		for idx, peer in pairs(interests) do
			if peer:isconnect() then
				print(idx, peer:getpeername())
				peer:read()	-- if donot read, interests remain
			end
		end
	end
end
