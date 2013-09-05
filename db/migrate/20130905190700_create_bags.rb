class CreateBags < ActiveRecord::Migration
  def change
    create_table :bags do |t|
      t.string :path
      t.references :institution, index: true

      t.timestamps
    end
  end
end
