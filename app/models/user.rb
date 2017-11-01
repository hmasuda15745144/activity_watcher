class User < ApplicationRecord
  
  include ActiveRecord::Confirmable
  
  with_options if: :user_registration_context do
    VALID_EMAIL_DEFAULT = /\A\S+@\S+\.\S+\z/
    validates :email,
      presence: true,
      uniqueness: true,
      length: { maximum: 128 },
      format: { with: VALID_EMAIL_DEFAULT, message: "は正しいアドレスではありません" }
      
    validates :user_full_name,
      presence: true,
      length: { maximum: 64 }
      
    validates :slack_user, 
      presence: true,
      length: { maximum: 64 }
      
    validates :student_no,
      presence: true,
      length: { maximum: 64 }
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.user_name = auth['info']['nickname']
      user.oauth_token = auth['credentials']['token']
    end
  end
  
  def user_registration_context
    validation_context == :user_registration
  end
  
end
