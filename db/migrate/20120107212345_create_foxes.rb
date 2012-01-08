class CreateFoxes < ActiveRecord::Migration
  def change
    create_table :foxes do |t|
      t.string :name, :limit => 45, :null => false
      t.decimal :lat, :precision => 16, :scale => 13, :null => false, :default => '47.228752'
      t.decimal :lon, :precision => 16, :scale => 13, :null => false, :default => '39.715587'
    end
  end
end
