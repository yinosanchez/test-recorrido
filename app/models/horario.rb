class Horario < ApplicationRecord
  belongs_to :servicio

  def self.period_start(servicio_id)
    first_horario = Horario.where(servicio_id: servicio_id).order(fecha: :asc).first
    if first_horario.nil?
      return Date.today
    else
      return first_horario.fecha
    end
  end

  def self.get_week(servicio_id, monday)
    dict_horarios = {}
    horarios = Horario.where(servicio_id: servicio_id).where(fecha: monday..monday+7.days).all
    horarios.each do |horario|
      dict_horarios[horario.fecha.to_s+'_'+horario.hora.to_s] = true
    end
    return dict_horarios
  end

  def self.get_week_ids(servicio_id, monday)
    dict_horarios = {}
    horarios = Horario.where(servicio_id: servicio_id).where(fecha: monday..monday+7.days).all
    horarios.each do |horario|
      dict_horarios[horario.fecha.to_s+'_'+horario.hora.to_s] = horario.id
    end
    return dict_horarios
  end

  def self.get_week_horarios(servicio_id, monday)
    return Horario.where(servicio_id: servicio_id).where(fecha: monday..monday+7.days).all
  end

  def self.get_week_hour_range(servicio_id, monday)
    hora_min = 23
    hora_max = 0
    horarios = Horario.where(servicio_id: servicio_id).where(fecha: monday..monday+7.days).all
    horarios.each do |horario|
      if(horario.hora < hora_min)
        hora_min = horario.hora
      end
      if(horario.hora > hora_max)
        hora_max = horario.hora
      end
    end
    return [hora_min, hora_max]
  end

  def self.clear_week(servicio_id, monday)
    Horario.where(servicio_id: servicio_id).where(fecha: monday.to_date..(monday.to_date+7.days)).each do |horario|
      horario.destroy
    end
  end
end
