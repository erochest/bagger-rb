class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :institutions, :code, unique: true
  end
end
