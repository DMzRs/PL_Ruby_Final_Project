require 'tk'

class ViewWindow
  def initialize(root, ingredients_array)
    @root = root
    @ingredients = ingredients_array
    
    create_view_window
  end

  private

  def create_view_window
    view_window = TkToplevel.new(@root)
    view_window.title "View All Ingredients"
    view_window.resizable true, true

    # center view window on screen
    width = 900
    height = 500
    screen_w = @root.winfo_screenwidth.to_i
    screen_h = @root.winfo_screenheight.to_i
    pos_x = (screen_w - width) / 2
    pos_y = (screen_h - height) / 2
    view_window.geometry "#{width}x#{height}+#{pos_x}+#{pos_y}"

    # Title
    TkLabel.new(view_window) do
      text "All Ingredients"
      font 'Helvetica 18 bold'
      pack(pady: 12)
    end

    if @ingredients.empty?
      TkLabel.new(view_window) do
        text "No ingredients added yet."
        font 'Helvetica 12'
        foreground "gray"
        pack(pady: 50)
      end
      return
    end

    # Create frame for scrollbar and listbox
    list_frame = TkFrame.new(view_window)
    list_frame.pack(fill: :both, expand: true, padx: 10, pady: 10)

    scrollbar = TkScrollbar.new(list_frame)
    listbox = TkListbox.new(list_frame) do
      yscrollcommand { |*args| scrollbar.set(*args) }
      height 15
      width 90
      font 'Courier 12'
    end

    scrollbar.command { |*args| listbox.yview(*args) }

    @ingredients.each do |ingredient|
      listbox.insert(:end, ingredient.to_s)
    end

    listbox.pack(side: :left, fill: :both, expand: true)
    scrollbar.pack(side: :right, fill: :y)

    # Total cost
    total_cost = @ingredients.sum { |ing| ing.total_cost }
    TkLabel.new(view_window) do
      text "Total Cost: ₱#{total_cost.round(2)}"
      font 'Helvetica 14 bold'
      foreground "darkgreen"
      pack(pady: 12)
    end

    # Close button
    TkButton.new(view_window) do
      text "Close"
      font 'Helvetica 12 bold'
      width 14
      command { view_window.destroy }
      pack(pady: 8)
    end
  end
end
