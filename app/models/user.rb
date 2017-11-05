class User < ApplicationRecord
  
  include ActiveRecord::Confirmable
  
  enum authority: { Student: 1, Teacher: 2, Reviewer: 3 }
  
  attr_accessor :faculty_password   #教職員用の認証パスワード(テーブルには存在しない)
  
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
      uniqueness: { scope: [:university_id] },
      length: { maximum: 64 },  unless: 'authority != "Student"'  #受講生の場合
      
    validate :faculty_password_valid
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.user_name = auth['info']['nickname']
      user.email = auth['info']['email']
      user.oauth_token = auth['credentials']['token']
    end
  end
  
  def user_registration_context
    validation_context == :user_registration
  end
  
  def faculty_password_valid
    if authority != "Student"
      if faculty_password.blank?
        errors.add(:faculty_password, "を入力してください")
      elsif faculty_password != ENV['FACULTY_PASSWORD']
        errors.add(:faculty_password, "が正しくありません")
      end
    end
  end
  
end
