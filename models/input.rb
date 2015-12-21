require 'dynamoid'

class Input
  include Dynamoid::Document

  field :original, :string, {default: ''}
  field :reversed, :string, {default: ''}
  field :upcased, :string, {default: ''}
  field :downcased, :string, {default: ''}
  field :capitalized, :string, {default: ''}
end
