class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :status, null: false, default: "pending"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
