--test_hello_draw.lua
package.path = package.path..";../?.lua"


local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor;
local band = bit.band;
local bnot = bit.bnot;
local lshift = bit.lshift;

local xcb = require("xcb")()
local utils = require("test_utils")();

local Lib_XCB = Lib_XCB;



local function main ()

  local values = ffi.new("uint32_t[2]");

  -- geometric objects 
  local points = ffi.new("xcb_point_t[4]", {
    {10, 10},
    {10, 20},
    {20, 10},
    {20, 20}});

	local polyline = ffi.new("xcb_point_t[4]", {
    {50, 10},
    { 5, 20},     -- rest of points are relative 
    {25,-20},
    {10, 10}});

    local segments = ffi.new("xcb_segment_t[2]", {
    {100, 10, 140, 30},
    {110, 25, 130, 60}});

    local rectangles = ffi.new("xcb_rectangle_t[2]", {
    { 10, 50, 40, 20},
    { 80, 50, 10, 40}});

    local arcs = ffi.new("xcb_arc_t[2]", {
    {10, 100, 60, 40, 0, lshift(90, 6)},
    {90, 100, 55, 40, 0, lshift(270, 6)}});

	-- Open the connection to the X server 
  	local c = xcb_connect (nil, nil);

  	-- Get the first screen 
  	local screen = xcb_setup_roots_iterator (xcb_get_setup (c)).data;

  	-- Create black (foreground) graphic context 
 	local win = screen.root;

  	local foreground = xcb_generate_id (c);
  	local mask = bor(XCB_GC_FOREGROUND, XCB_GC_GRAPHICS_EXPOSURES);
  	values[0] = screen.black_pixel;
  	values[1] = 0;
  
  xcb_create_gc (c, foreground, win, mask, values);

  -- Generate an ID for our window
  local win = xcb_generate_id(c);

  -- Create the window 
  mask = bor(XCB_CW_BACK_PIXEL, XCB_CW_EVENT_MASK);
  values[0] = screen.white_pixel;
  values[1] = XCB_EVENT_MASK_EXPOSURE;
  xcb_create_window (c,                             -- Connection          
                     XCB_COPY_FROM_PARENT,          -- depth               
                     win,                           -- window Id           
                     screen.root,                  -- parent window       
                     0, 0,                          -- x, y                
                     150, 150,                      -- width, height       
                     10,                            -- border_width        
                     XCB_WINDOW_CLASS_INPUT_OUTPUT, -- class               
                     screen.root_visual,           -- visual              
                     mask, values);                 -- masks 

  -- Map the window on the screen 
  xcb_map_window (c, win);

  xcb_flush (c);

  while (true) do
  	local e = xcb_wait_for_event(c);
	local eType = band(e.response_type, bnot(0x80));

    if eType == XCB_EXPOSE then
      xcb_poly_point (c, XCB_COORD_MODE_ORIGIN, win, foreground, 4, points);

      xcb_poly_line (c, XCB_COORD_MODE_PREVIOUS, win, foreground, 4, polyline);

      xcb_poly_segment (c, win, foreground, 2, segments);

      xcb_poly_rectangle (c, win, foreground, 2, rectangles);

      xcb_poly_arc (c, win, foreground, 2, arcs);

      xcb_flush (c);

    else
      -- Unknown event type, ignore it 
    end
    
  end	-- while

  return 0;
end

main()

