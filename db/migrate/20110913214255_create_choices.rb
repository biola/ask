class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.belongs_to :question
      t.string :name

      t.timestamps
    end
    add_index :choices, :question_id
  end
end
