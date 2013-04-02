class ChangeLoginToUnique < ActiveRecord::Migration
  def up
      change_column :users, :login, :string, :null => false, :default => ""
  end

  def down
  end
end
