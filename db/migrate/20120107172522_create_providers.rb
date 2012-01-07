class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name, :limit => 45, :null => false
      t.timestamps
    end
  end
end
