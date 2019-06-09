class Company
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :logo

  field :name, type: String
  field :address, type: String
  field :total_views, type:Integer, default: 0
  field :unique_views, type:Integer, default: 0

  validates_with AttachmentSizeValidator, attributes: :logo, less_than: 1.megabytes

end
