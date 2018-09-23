class User < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.datetime :birthday
      t.string :email
      t.string :code_lang
      t.datetime :created_at
    end

  end
end
