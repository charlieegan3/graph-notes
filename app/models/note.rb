class Note < ApplicationRecord
  belongs_to :parent, class_name: "Note", required: false
  has_many :children, class_name: "Note", foreign_key: "parent_id"
  acts_as_taggable
end
