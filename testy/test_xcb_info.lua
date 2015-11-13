-- test_xcb_info.lua
--[[
    Display some information about the default screen 
    on the default DISPLAY
--]]

package.path = package.path..";../?.lua"

local ffi = require("ffi")

local xcb = require("xcb")
local utils = require("test_utils");
local printf = utils.printf

--local Lib_XCB = Lib_XCB;


local function main ()
    -- Open the connection to the X server. Use the DISPLAY environment variable */
    local screenNum = ffi.new("int[1]");
    local connection = xcb.xcb_connect (nil, screenNum);
    local screen = xcb.xcb_setup_roots_iterator(xcb.xcb_get_setup(connection)).data;

    print("Screen: ", screen, screen.root, screenNum[0]);


    -- report
    printf ("\n");
    printf ("Information of screen %d:\n", screenNum[0]);       -- "PRIu32"
    printf ("  width.........: %d\n", screen.width_in_pixels);  -- "PRIu16"
    printf ("  height........: %d\n", screen.height_in_pixels); -- "PRIu16"

    printf ("  white pixel...: 0x%x\n", screen.white_pixel);      -- "PRIu32"
    printf ("  black pixel...: 0x%x\n", screen.black_pixel);      -- "PRIu32"
    printf ("\n");

end

main()

