# This migration comes from ask_engine (originally 20130128214410)
class AddPropertiesToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :properties, :text
    add_column :answers, :type, :string
  end
end
