# coding: utf-8

class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id, :default => nil, :comment => 'Результат getDeviceId()'
      t.string :sim_id, :default => nil, :comment =>'Результат getSimSerialNumber()'
      t.timestamps
    end
  end
end
