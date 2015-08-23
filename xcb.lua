-- xcb.lua
local ffi = require("ffi")

local xcb_ffi = require("xcb_ffi")

local exports = {
	xcb_ffi = xcb_ffi;	
}

setmetatable(exports, {
	__call = function(self, ...)
		self.xcb_ffi();
		
		return self;
	end,
})

return exports
