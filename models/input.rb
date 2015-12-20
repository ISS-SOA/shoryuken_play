require 'dynamoid'

class Input
  include Dynamoid::Document

  field :original, :string
  field :reversed, :string
  field :upcase, :string
  field :downcase, :string
  field :capitalized, :string
end
