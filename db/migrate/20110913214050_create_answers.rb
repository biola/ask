class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :submission
      t.belongs_to :question
      t.belongs_to :choice
      t.text :answer

      t.timestamps
    end
    add_index :answers, :submission_id
    add_index :answers, :question_id
    add_index :answers, :choice_id
  end
end
