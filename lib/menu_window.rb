require 'tk'
require_relative 'add_window'
require_relative 'update_window'
require_relative 'view_window'

class MenuWindow
  def initialize(root)
    @root = root
    @ingredients = []
    
    create_menu_window
  end

  private

  def create_menu_window
    @root.title "Burger Inventory - Main Menu"
    @root.resizable false, false

    # Title
    TkLabel.new(@root) do
      text "Burger Ingredients Inventory"
      font 'Helvetica 20 bold'
      pack(pady: 24)
    end

    # Image (75x75)
    original_image = TkPhotoImage.new(file: "photos/burger_icon.png")
    image = TkPhotoImage.new(width: 100, height: 100)
    image.copy(original_image, subsample: 2)
    TkLabel.new(@root) do
      image image
      pack(pady: 4)
    end

    # Button Frame
    button_frame = TkFrame.new(@root)
    button_frame.pack(pady: 10)

    # prepare callback references so `self` inside the Tk blocks doesn't change scope
    root = @root
    ingredients = @ingredients
    refresh_cb = method(:refresh_menu)
    show_delete_cb = method(:show_delete_dialog)
    exit_cb = proc { root.destroy }

    # Add Button
    TkButton.new(button_frame) do
      text "Add Ingredient"
      width 26
      font 'Helvetica 12 bold'
      command { AddWindow.new(root, ingredients, refresh_cb) }
      pack(pady: 6)
    end

    # View Button
    TkButton.new(button_frame) do
      text "View All Ingredients"
      width 26
      font 'Helvetica 12 bold'
      command { ViewWindow.new(root, ingredients) }
      pack(pady: 6)
    end

    # Update Button
    TkButton.new(button_frame) do
      text "Update Ingredient"
      width 26
      font 'Helvetica 12 bold'
      command { UpdateWindow.new(root, ingredients, refresh_cb) }
      pack(pady: 6)
    end

    # Delete Button
    TkButton.new(button_frame) do
      text "Delete Ingredient"
      width 26
      font 'Helvetica 12 bold'
      command { show_delete_cb.call }
      pack(pady: 6)
    end

    # Exit Button
    TkButton.new(button_frame) do
      text "Exit"
      width 26
      font 'Helvetica 12 bold'
      command { exit_cb.call }
      pack(pady: 6)
    end

    @info_label = TkLabel.new(@root) do
      text "Total Ingredients: 0 | Total Cost: ₱0.00"
      font 'Helvetica 12'
      pack(pady: 12)
    end
  end

  def show_delete_dialog
    # Capture locals so `self` changes inside Tk blocks don't affect access
    ingredients = @ingredients
    refresh_cb = method(:refresh_menu)

    if ingredients.empty?
      Tk.messageBox(type: :ok, icon: :info, title: "No Ingredients", message: "No ingredients to delete.")
      return
    end

    delete_window = TkToplevel.new(@root)
    delete_window.title "Delete Ingredient"
    delete_window.resizable false, false

    # center delete window on screen
    width = 900
    height = 500
    screen_w = @root.winfo_screenwidth.to_i
    screen_h = @root.winfo_screenheight.to_i
    pos_x = (screen_w - width) / 2
    pos_y = (screen_h - height) / 2
    delete_window.geometry "#{width}x#{height}+#{pos_x}+#{pos_y}"

    TkLabel.new(delete_window) do
      text "Select an ingredient to delete:"
      font 'Helvetica 16 bold'
      pack(pady: 10)
    end

    # Frame to hold listbox + scrollbar and make layout proportionate
    list_frame = TkFrame.new(delete_window)
    list_frame.pack(fill: :both, expand: true, padx: 20, pady: 10)

    scrollbar = TkScrollbar.new(list_frame)
    listbox = TkListbox.new(list_frame) do
      yscrollcommand { |*args| scrollbar.set(*args) }
      height 15
      width 60
      font 'Courier 12'
      selectmode :single
    end

    scrollbar.command { |*args| listbox.yview(*args) }

    ingredients.each_with_index do |ingredient, index|
      listbox.insert(:end, ingredient.to_s)
    end

    listbox.pack(side: :left, fill: :both, expand: true)
    scrollbar.pack(side: :right, fill: :y)

    button_frame = TkFrame.new(delete_window)
    button_frame.pack(pady: 10)

    TkButton.new(button_frame) do
      text "Delete"
      font 'Helvetica 13 bold'
      command do
        selection = listbox.curselection
        if selection.empty?
          Tk.messageBox(type: :ok, icon: :warning, title: "Selection Error", message: "Please select an ingredient.")
        else
          ingredients.delete_at(selection[0])
          Tk.messageBox(type: :ok, icon: :info, title: "Success", message: "Ingredient deleted successfully!")
          delete_window.destroy
          refresh_cb.call
        end
      end
      pack(side: :left, padx: 5)
    end

    TkButton.new(button_frame) do
      text "Cancel"
      font 'Helvetica 13 bold'
      command { delete_window.destroy }
      pack(side: :left, padx: 5)
    end
  end

  def refresh_menu
    total_cost = @ingredients.sum { |ing| ing.total_cost }
    @info_label.text = "Total Ingredients: #{@ingredients.length} | Total Cost: ₱#{total_cost.round(2)}"
  end
end
