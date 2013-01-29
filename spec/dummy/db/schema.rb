# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130129190827) do

  create_table "answers", :force => true do |t|
    t.integer  "answerer_id"
    t.string   "answerer_type"
    t.integer  "question_id"
    t.integer  "choice_id"
    t.text     "answer"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "properties"
    t.string   "type"
  end

  add_index "answers", ["answerer_id", "answerer_type"], :name => "index_answers_on_answerer_id_and_answerer_type"
  add_index "answers", ["choice_id"], :name => "index_answers_on_choice_id"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "choices", :force => true do |t|
    t.integer  "question_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "choices", ["question_id"], :name => "index_choices_on_question_id"

  create_table "forms", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "asker_id"
    t.string   "asker_type"
    t.string   "type"
    t.string   "name"
    t.text     "instructions"
    t.boolean  "required"
    t.integer  "position"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "questions", ["asker_id", "asker_type"], :name => "index_questions_on_asker_id_and_asker_type"

  create_table "submissions", :force => true do |t|
    t.integer  "form_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
