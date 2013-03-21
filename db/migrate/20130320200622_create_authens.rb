class CreateAuthens < ActiveRecord::Migration
  def self.up
    create_table :authens do |t|
      t.integer :user_id
      t.string :provier
      t.string :uid
      t.timestamps
    end
  end

  def self.down
    drop_table :authens
  end
end
