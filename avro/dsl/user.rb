# frozen_string_literal: true

record :user do
  required :name, :string
  required :email, :string
  optional :age, :int
end
