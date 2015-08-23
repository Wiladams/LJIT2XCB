-- test_xcb_info.lua

package.path = package.path..";../?.lua"

local ffi = require("ffi")

local xcb = require("xcb")()
local utils = require("test_utils")();

local Lib_XCB = Lib_XCB;

xcb_connect = Lib_XCB.xcb_connect;
xcb_get_setup = Lib_XCB.xcb_get_setup;
xcb_setup_roots_iterator = Lib_XCB.xcb_setup_roots_iterator;
xcb_screen_next = Lib_XCB.xcb_screen_next;

local function main ()
    -- Open the connection to the X server. Use the DISPLAY environment variable */
    local screenNum = ffi.new("int[1]");
    local connection = xcb_connect (nil, screenNum);

    -- Get the screen whose number is screenNum */
    local setup = xcb_get_setup (connection);
print("Setup: ", setup);
    local iter = xcb_setup_roots_iterator (setup);  


    -- we want the screen at index screenNum of the iterator
    print("ScreenNum[0]: ", screenNum[0])

    local i = 0;
    while i<= screenNum[0] do
        xcb_screen_next (iter);
        i = i + 1;
    end
    
    local screen = iter.data;
    print("Screen: ", screen);


    -- report
    printf ("\n");
    printf ("Informations of screen %d:\n", screen.root);       -- "PRIu32"
    printf ("  width.........: %d\n", screen.width_in_pixels);  -- "PRIu16"
    printf ("  height........: %d\n", screen.height_in_pixels); -- "PRIu16"

    printf ("  white pixel...: %d\n", screen.white_pixel);      -- "PRIu32"
    printf ("  black pixel...: %d\n", screen.black_pixel);      -- "PRIu32"
    printf ("\n");

end

main()

