class CreateHorarios < ActiveRecord::Migration[6.1]
  def change
    create_table :horarios do |t|
      t.references :servicio, null: false, foreign_key: true
      t.date :fecha
      t.integer :hora

      t.timestamps
    end
  end
end
