class CreateDisponibles < ActiveRecord::Migration[6.1]
  def change
    create_table :disponibles do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :horario, null: false, foreign_key: true
      t.boolean :asignado

      t.timestamps
    end
  end
end
