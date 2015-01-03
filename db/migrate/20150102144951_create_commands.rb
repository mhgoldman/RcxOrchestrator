class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.text :description
      t.string :path
      t.string :args

      t.timestamps null: false
    end
  end
end
