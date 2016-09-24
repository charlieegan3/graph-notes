class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :link
      t.text :comment
      t.references :parent

      t.timestamps
    end
  end
end
