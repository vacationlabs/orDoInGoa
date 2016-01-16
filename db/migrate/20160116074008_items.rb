class Items < ActiveRecord::Migration
  def up
    create_table :goan_items do |t|
      t.string :name
      t.integer :cost
    end
  end

  def down
    drop_table :goan_items
  end
end
