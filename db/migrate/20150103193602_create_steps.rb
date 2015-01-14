class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :batch_id
      t.integer :command_id
      t.integer :index

      t.timestamps null: false
    end
  end
end
