class AddEmailDomainToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :email_domain, :string, limit: 64, null: false, default: ""
  end
end
