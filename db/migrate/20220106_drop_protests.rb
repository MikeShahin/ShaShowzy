class DropProtests < ActiveRecord::Migration
    def change
      drop_table :protests
    end
  end
  