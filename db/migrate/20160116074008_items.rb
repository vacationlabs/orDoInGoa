class Items < ActiveRecord::Migration
  def change
    create_table :goan_items do |t|
      t.string :name
      t.integer :cost
    end
  end
end
