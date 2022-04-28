# frozen_string_literal: true

record :order_created do
  required :name, :string
  required :line_items, :array, items: :string
  optional :tracking_number, :string
  required :comments, :string
end
