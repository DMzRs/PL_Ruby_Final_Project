require 'tk'
require_relative 'ingredient'

class AddWindow
  def initialize(root, ingredients_array, callback)
    @root = root
    @ingredients = ingredients_array
    @callback = callback
    
    create_add_window
  end

  private

  def create_add_window
    add_window = TkToplevel.new(@root)
    add_window.title "Add New Ingredient"
    add_window.resizable false, false

    # center add window on screen
    width = 900
    height = 500
    screen_w = @root.winfo_screenwidth.to_i
    screen_h = @root.winfo_screenheight.to_i
    pos_x = (screen_w - width) / 2
    pos_y = (screen_h - height) / 2
    add_window.geometry "#{width}x#{height}+#{pos_x}+#{pos_y}"

    # Capture instance vars into locals so Tk blocks keep the right references
    ingredients = @ingredients
    callback = @callback

    # Title
    TkLabel.new(add_window) do
      text "Add New Ingredient"
      font 'Helvetica 18 bold'
      pack(pady: 18)
    end

    # Name Label and Entry
    TkLabel.new(add_window) do
      text "Ingredient Name:"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    name_entry = TkEntry.new(add_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 10])
    end

    # Quantity Label and Entry
    TkLabel.new(add_window) do
      text "Quantity:"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    quantity_entry = TkEntry.new(add_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 10])
    end

    # Price Label and Entry
    TkLabel.new(add_window) do
      text "Price per Unit (₱):"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    price_entry = TkEntry.new(add_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 20])
    end

    # Button Frame
    button_frame = TkFrame.new(add_window)
    button_frame.pack(pady: 10)

    # Add Button
    TkButton.new(button_frame) do
      text "Add"
      width 14
      font 'Helvetica 12 bold'
      command do
        name = name_entry.value.strip
        quantity = quantity_entry.value.strip
        price = price_entry.value.strip

        if name.empty? || quantity.empty? || price.empty?
          Tk.messageBox(type: :ok, icon: :error, title: "Error", message: "All fields are required!")
        elsif quantity.to_i <= 0
          Tk.messageBox(type: :ok, icon: :error, title: "Error", message: "Quantity must be greater than 0!")
        elsif price.to_f <= 0
          Tk.messageBox(type: :ok, icon: :error, title: "Error", message: "Price must be greater than 0!")
        else
          ingredients << Ingredient.new(name, quantity, price)
          Tk.messageBox(type: :ok, icon: :info, title: "Success", message: "Ingredient added successfully!")
          callback.call
          add_window.destroy
        end
      end
      pack(side: :left, padx: 5)
    end

    # Cancel Button
    TkButton.new(button_frame) do
      text "Cancel"
      width 14
      font 'Helvetica 12 bold'
      command { add_window.destroy }
      pack(side: :left, padx: 5)
    end
  end
end
