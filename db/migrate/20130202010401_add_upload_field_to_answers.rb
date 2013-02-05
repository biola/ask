class AddUploadFieldToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :uploaded_file, :string
  end
end
