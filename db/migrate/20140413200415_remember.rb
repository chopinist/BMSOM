class Remember < ActiveRecord::Migration
  def change

    create_table "remember_tokens", force: true do |t|
      t.integer "user_id"
      t.string  "remember_token"
    end


  end
end
