class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  include Mongoid::Paperclip
  has_secure_password

  has_mongoid_attached_file :image

  field :name, type: String
  field :job_role, type: String
  field :email, type:String
  field :password_digest, type:String
  field :auth_token
  field :auth_expiry_time


  belongs_to :company, index: true, optional: false

  validates_with AttachmentSizeValidator, attributes: :image, less_than: 1.megabytes

  
  def generate_auth_token
  	self.auth_token = SecureRandom.base64(8)
  	self.auth_expiry_time = Time.now()+60.minutes
  	self.save
  end

end
