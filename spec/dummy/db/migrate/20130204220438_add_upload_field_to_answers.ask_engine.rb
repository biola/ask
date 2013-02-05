# This migration comes from ask_engine (originally 20130202010401)
class AddUploadFieldToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :uploaded_file, :string
  end
end
