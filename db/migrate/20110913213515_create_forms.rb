class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.belongs_to :asker, :polymorphic => true
      t.string :type
      t.string :name
      t.text :instructions
      t.boolean :required

      t.timestamps
    end
    add_index :forms, :asker_id
  end
end
