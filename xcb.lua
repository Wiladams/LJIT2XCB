-- xcb.lua
local ffi = require("ffi")

local xcb_ffi = require("xcb_ffi")

local C = {
	-- some constants
    X_PROTOCOL = 11;
    X_PROTOCOL_REVISION = 0;
    X_TCP_PORT = 6000;
    XCB_CONN_ERROR = 1;
    XCB_CONN_CLOSED_EXT_NOTSUPPORTED = 2;
    XCB_CONN_CLOSED_MEM_INSUFFICIENT = 3;
    XCB_CONN_CLOSED_REQ_LEN_EXCEED = 4;
    XCB_CONN_CLOSED_PARSE_ERR = 5;
    XCB_CONN_CLOSED_INVALID_SCREEN = 6;
    XCB_CONN_CLOSED_FDPASSING_FAILED = 7;

	XCB_NONE = 0;
	XCB_COPY_FROM_PARENT = 0;
	XCB_CURRENT_TIME = 0;
	XCB_NO_SYMBOL = 0;
}

local exports = {
	xcb_ffi = xcb_ffi;	
}

local function lookupInLibrary(key)
	local success, value = pcall(function() return xcb_ffi[key] end)
	print("lookupInLibrary: ", success, key, value)

	if success then
		return value;
	end

	return nil;
end

local function lookupTypeName(key)
	local success, value = pcall(function() return ffi.typeof(key) end)

	if success then
		return value;
	end

	return nil;
end

setmetatable(exports, {
	__index = function(self, key)
print("__index: ", key)
		local value = nil;
		local success = false;

		-- look it up in the constants

		value = C[key]
		if value then
			rawset(self, key, value)
			print("  CONSTANT: ",value)
			return value;
		end
		
		-- try looking in the library.  This will find functions
		-- constants, and enums, or return nil if not found
		value = lookupInLibrary(key)
		if value then
			rawset(self, key, value);
			print("  FUNCTION")
			return value;
		end

--[[
		-- try looking in the ffi.C namespace, for constants
		-- and enums
		success, value = pcall(function() return ffi.C[key] end)
		if success then
			rawset(self, key, value);
			return value;
		end
--]]

		-- Or maybe it's a type, use ffi.typeof
		value = lookupTypeName(key)
		if value then
			rawset(self, key, value);
			print("  TYPEOF: ", key, value)
			return value;
		end

		print("  UNKNOWN")

		return nil;
	end,
})


return exports
