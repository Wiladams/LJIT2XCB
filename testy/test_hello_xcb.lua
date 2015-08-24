--test_hello_xcb.lua

--[[
  Reference: http://www.x.org/releases/X11R7.6/doc/libxcb/tutorial/index.html#helloworld

  Press Ctl-C to terminate
  Simply closing the window will not terminate the app
--]]

package.path = package.path..";../?.lua"


local ffi = require("ffi")

local xcb = require("xcb")()
local utils = require("test_utils")();

local Lib_XCB = Lib_XCB;

ffi.cdef[[
extern int pause (void);
]]
local pause = ffi.C.pause;


local function main ()

  -- Open the connection to the X server 
  local c = xcb_connect (nil, nil);

  -- Get the first screen 
  local screen = xcb_setup_roots_iterator (xcb_get_setup (c)).data;

  -- Ask for our window's Id 
  local win = xcb_generate_id(c);

  -- Create the window 
  xcb_create_window (c,                             -- Connection          
                     XCB_COPY_FROM_PARENT,          -- depth (same as root)
                     win,                           -- window Id           
                     screen.root,                  -- parent window       
                     0, 0,                          -- x, y                
                     150, 150,                      -- width, height       
                     10,                            -- border_width        
                     XCB_WINDOW_CLASS_INPUT_OUTPUT, -- class               
                     screen.root_visual,           -- visual              
                     0, nil);                      -- masks, not used yet 

  -- Map the window on the screen 
  xcb_map_window (c, win);

  -- Make sure commands are sent before we pause, so window is shown 
  xcb_flush (c);

  -- hold client until Ctrl-C 
  pause ();    

  return 0;
end

main()
