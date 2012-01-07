# coding: utf-8

class CreateFixes < ActiveRecord::Migration
  def change
    create_table :fixes do |t|
      t.decimal :lat, :precision => 16, :scale => 13, :comment => 'Широта'
      t.decimal :lon, :precision => 16, :scale => 13, :comment => 'Широта'
      t.decimal :alt, :precision => 16, :scale => 13, :comment => 'Высота'
      t.decimal :acc, :precision => 16, :scale => 13, :comment => 'Высота'
      t.time :client_time, :default => Time.now, :comment => 'Время фикса, указанное клиентом'
      t.integer :provider_id, :default => nil
      t.integer :device_id, :default => nil
      t.integer :user_id, :null => false
      t.decimal :speed, :default => nil
      t.decimal :bearing, :default => nil

      t.timestamps
    end

    [:provider_id, :device_id, :user_id].each do |column|
      add_index :fixes, column
    end
  end
end
