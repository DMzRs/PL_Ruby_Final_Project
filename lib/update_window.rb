require 'tk'
require_relative 'ingredient'

class UpdateWindow
  def initialize(root, ingredients_array, callback)
    @root = root
    @ingredients = ingredients_array
    @callback = callback
    
    create_update_window
  end

  private

  def create_update_window
    if @ingredients.empty?
      Tk.messageBox(type: :ok, icon: :info, title: "No Ingredients", message: "No ingredients to update.")
      return
    end

    update_window = TkToplevel.new(@root)
    update_window.title "Update Ingredient"
    update_window.resizable false, false

    # center update window on screen
    width = 900
    height = 500
    screen_w = @root.winfo_screenwidth.to_i
    screen_h = @root.winfo_screenheight.to_i
    pos_x = (screen_w - width) / 2
    pos_y = (screen_h - height) / 2
    update_window.geometry "#{width}x#{height}+#{pos_x}+#{pos_y}"

    # Title
    TkLabel.new(update_window) do
      text "Update Ingredient"
      font 'Helvetica 18 bold'
      pack(pady: 18)
    end

    # Select ingredient
    TkLabel.new(update_window) do
      text "Select Ingredient:"
      font 'Helvetica 14 bold'
      width 37
      anchor :center
      pack(padx: 20, pady: [5, 0])
    end

    # Capture instance vars into locals so Tk blocks keep the correct references
    ingredients = @ingredients
    callback = @callback

    ingredient_var = TkVariable.new
    ingredient_combo = TkCombobox.new(update_window) do
      textvariable ingredient_var
      values ingredients.map(&:name)
      state :readonly
      width 30
      pack(padx: 20, pady: [0, 15])
    end

    # Name Label and Entry
    TkLabel.new(update_window) do
      text "Ingredient Name:"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    name_entry = TkEntry.new(update_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 10])
    end

    # Quantity Label and Entry
    TkLabel.new(update_window) do
      text "Quantity:"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    quantity_entry = TkEntry.new(update_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 10])
    end

    # Price Label and Entry
    TkLabel.new(update_window) do
      text "Price per Unit (₱):"
      font 'Helvetica 12 bold'
      width 37
      anchor :w
      pack(padx: 20, pady: [5, 0])
    end

    price_entry = TkEntry.new(update_window) do
      font 'Helvetica 12'
      width 40
      pack(padx: 20, pady: [0, 15])
    end

    # Load selected ingredient details
    ingredient_combo.bind('<ComboboxSelected>') do
      selected_name = ingredient_var.value
      selected_ingredient = ingredients.find { |ing| ing.name == selected_name }
      if selected_ingredient
        name_entry.delete(0, :end)
        name_entry.insert(0, selected_ingredient.name)
        quantity_entry.delete(0, :end)
        quantity_entry.insert(0, selected_ingredient.quantity.to_s)
        price_entry.delete(0, :end)
        price_entry.insert(0, selected_ingredient.price.to_s)
      end
    end

    # Button Frame
    button_frame = TkFrame.new(update_window)
    button_frame.pack(pady: 10)

    # Update Button
    TkButton.new(button_frame) do
      text "Update"
      width 14
      font 'Helvetica 12 bold'
      command do
        selected_name = ingredient_var.value
        selected_ingredient = ingredients.find { |ing| ing.name == selected_name }

        if selected_ingredient.nil?
          Tk.messageBox(type: :ok, icon: :error, title: "Error", message: "Please select an ingredient!")
        else
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
            selected_ingredient.name = name
            selected_ingredient.quantity = quantity.to_i
            selected_ingredient.price = price.to_f
            Tk.messageBox(type: :ok, icon: :info, title: "Success", message: "Ingredient updated successfully!")
            callback.call
            update_window.destroy
          end
        end
      end
      pack(side: :left, padx: 5)
    end

    # Cancel Button
    TkButton.new(button_frame) do
      text "Cancel"
      width 14
      font 'Helvetica 12 bold'
      command { update_window.destroy }
      pack(side: :left, padx: 5)
    end
  end
end
