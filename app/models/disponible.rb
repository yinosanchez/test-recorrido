class Disponible < ApplicationRecord
  belongs_to :usuario
  belongs_to :horario

  def self.get_usuario_servicio_week(usuario_id, servicio_id, monday)
    disponible_dict = {}
    disponibles = Disponible.joins(:horario).where(horarios: { servicio_id: servicio_id, fecha: monday..monday+7.days }).where(usuario_id: usuario_id).all
    disponibles.each do |disponible|
      disponible_dict[disponible.horario_id] = true
    end
    return disponible_dict
  end

  def self.clear_week(usuario_id, servicio_id, monday)
    disponibles = Disponible.joins(:horario).where(horarios: { servicio_id: servicio_id, fecha: monday..monday+7.days }).where(usuario_id: usuario_id).all
    disponibles.each do |disponible|
      disponible.destroy
    end
  end

  def self.get_monitores_week(servicio_id, monday)
    disponibles = {}
    Disponible.joins(:horario).where(horarios: { servicio_id: servicio_id, fecha: monday..monday+7.days }).each do |disponible|
      disponibles[disponible.horario_id] = disponibles[disponible.horario_id] ? disponibles[disponible.horario_id].push(disponible) : [disponible] 
    end
    return disponibles
  end
end
