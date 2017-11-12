class User < ApplicationRecord
  
  include ActiveRecord::Confirmable
  
  enum authority: { Student: 1, Teacher: 2, Reviewer: 3 }
  
  attr_accessor :teachers_password   #教職員用の認証パスワード(テーブルには存在しない)
  
  with_options if: :user_registration_context do
    VALID_EMAIL_DEFAULT = /\A\S+@\S+\.\S+\z/
    validates :email,
      presence: true,
      uniqueness: true,
      length: { maximum: 128 },
      format: { with: VALID_EMAIL_DEFAULT, message: "は正しいアドレスではありません", allow_blank: true }
    
    validate :email_domain_valid

    validates :user_full_name,
      presence: true,
      length: { maximum: 64 }
      
    validates :slack_user, 
      presence: true,
      length: { maximum: 64 }
  end
  
  with_options if: :user_registration_context_is_student do
    validates :student_no,
      presence: true,
      uniqueness: { scope: [:university_id] },
      length: { maximum: 64 }
  end
  
  with_options if: :user_registration_context_is_not_student do
    validate :teachers_password_valid
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
  
  def user_registration_context_is_student
    user_registration_context && is_student?
  end
  
  def user_registration_context_is_not_student
    user_registration_context && (is_teacher? || is_reviewer?)
  end
  
  def is_student?
    authority == "Student"
  end
  
  def is_teacher?
    authority == "Teacher"
  end
  
  def is_reviewer?
    authority == "Reviewer"
  end
  
  def teachers_password_valid
    if teachers_password.blank?
      errors.add(:teachers_password, "を入力してください")
    elsif teachers_password != ENV['TEACHERS_PASSWORD']
      errors.add(:teachers_password, "が正しくありません")
    end
  end
  
  def email_domain_valid
    return if email.blank?
    email_domain = University.find_by(id: university_id).email_domain
    valid_email_domain = /\A[\w+-.]+@+#{email_domain}\z/
    unless email.match(valid_email_domain)
      errors.add(:email, "のドメインが正しくありません")
    end
  end
  
end
