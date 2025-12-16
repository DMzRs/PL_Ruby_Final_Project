require 'tk'
require_relative 'lib/ingredient'
require_relative 'lib/menu_window'

# Initialize Tk root window
width = 900
height = 500

root = TkRoot.new do
  title "Burger Inventory System"
  resizable false, false
end

screen_w = root.winfo_screenwidth.to_i
screen_h = root.winfo_screenheight.to_i
pos_x = (screen_w - width) / 2
pos_y = (screen_h - height) / 2
root.geometry "#{width}x#{height}+#{pos_x}+#{pos_y}"

# Start with menu window
MenuWindow.new(root)

Tk.mainloop
