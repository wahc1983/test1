class RenameUsernameToLogin < ActiveRecord::Migration
  def up
	rename_column :users, :username, :login
  end

  def down
        rename_column :users, :login, :username
  end
end
