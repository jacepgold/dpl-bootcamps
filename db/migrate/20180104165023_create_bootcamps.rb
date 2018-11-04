class CreateBootcamps < ActiveRecord::Migration[5.1]
  def change
    create_table :bootcamps do |t|
      t.string :name, null: false, default: ''
      t.integer :year_founded, null: false, default: Date.today.year
      t.boolean :active, default: true
      t.jsonb :languages
      t.float :full_time_tuition_cost, null: false, default: 0.0
      t.float :part_time_tuition_cost, null: false, default: 0.0

      t.timestamps
    end
  end
end
