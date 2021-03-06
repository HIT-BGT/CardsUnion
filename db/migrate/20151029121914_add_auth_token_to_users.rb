class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    Account.all.each do |user|
      user.generate_token(:auth_token)
    end
  end
end
