class Assister < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relationships
  has_many :visitors

  # # Paperclip
  # # Still need to create file attachment functionality in assister model
  # # Need to change attachment content types

  # has_attached_file :certification
  # validates_attachment_content_type :certification, :content_type => ["application/pdf",
             # "application/msword", 
             # "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             # "image/jpg"
             # "" ]


end
