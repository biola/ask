# This migration comes from ask_engine (originally 20110913214255)
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
