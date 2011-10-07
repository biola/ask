class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :asker, :polymorphic => true
      t.string :type
      t.string :name
      t.text :instructions
      t.boolean :required
      t.integer :position

      t.timestamps
    end
    add_index :questions, [:asker_id, :asker_type]
  end
end
