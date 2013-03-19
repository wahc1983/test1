class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :titulo
      t.text :contenido

      t.timestamps
    end
  end
end
