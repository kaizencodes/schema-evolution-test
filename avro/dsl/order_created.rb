record :order_created do
  required :name, :string
  required :line_items, :array, items: :string
end