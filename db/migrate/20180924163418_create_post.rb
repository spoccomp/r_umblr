class CreatePost < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.datetime :created_at
      t.datetime :updated_at
      # this is to create a foreign key
      t.references :users 
    end
  end
end
