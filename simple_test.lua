l = require "lssock"

local server = assert(l.new())
assert(server:bind("*", 8899))
assert(server:listen())

while l.sleep(10) do
	local peer = server:accept()
	if peer then
		print("peername", peer:getpeername())	-- hostip, port
		peer:write("hello world\n")		-- blocking while `write again`
		local data = peer:read(5)		-- nonblock
		if data then
			print("data : ", data)
		end
		peer:close()
	end
end
server:shutdown()


