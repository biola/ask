class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :submitter, :polymorphic => true
      t.belongs_to :form

      t.timestamps
    end
    add_index :submissions, :submitter_id
    add_index :submissions, :form_id
  end
end
