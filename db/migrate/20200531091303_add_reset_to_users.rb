class AddResetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :reset_send_at, :string
    add_column :users, :datetime, :string
  end
end
