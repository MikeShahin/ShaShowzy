class DropProtests < ActiveRecord::Migration[6.0]
    def change
      drop_table :protests
    end
  end
  