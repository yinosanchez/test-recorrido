class DisponiblesController < ApplicationController
  before_action :authenticate_usuario!
  layout false, only: [:week_form, :disponibilidad, :monitores]

  def servicio_form
    @servicios = Servicio.list_for_form
  end

  def week_form
    @weeks = {}
    start_date = Horario.period_start(params[:servicio_id])
    start_week_number = start_date.strftime("%W").to_i
    week_number = Date.today.strftime("%W").to_i
    year = Date.today.year
    (start_week_number..week_number+5).each do |week_num|
      if(week_num > 52)
        week_start = Date.commercial( year+1, week_num-52, 1 )
        week_end = Date.commercial( year+1, week_num-52, 7 )
      else
        week_start = Date.commercial( year, week_num, 1 )
        week_end = Date.commercial( year, week_num, 7 )
      end
      @weeks[year.to_s+'_'+week_num.to_s] = week_start.strftime( "%d/%m/%y" ) + ' al ' + week_end.strftime("%d/%m/%y" )
    end
  end

  def disponibilidad
    year = params[:chosen_week].split('_')[0].to_i
    week = params[:chosen_week].split('_')[1].to_i
    @week_start = Date.commercial( year, week, 1 )
    @servicio_id = params[:servicio_id]
    @hour_range = Horario.get_week_hour_range(params[:servicio_id], @week_start)
    @horarios = Horario.get_week_ids(params[:servicio_id], @week_start)
    @disponibles = Disponible.get_usuario_servicio_week(current_usuario.id, params[:servicio_id], @week_start)
  end

  def update_disponibilidad
    week_start = params['week_start']
    servicio_id = params[:servicio_id]
    Disponible.clear_week(current_usuario.id, servicio_id, week_start.to_date)
    horarios = Horario.get_week_ids(servicio_id, week_start.to_date)
    horarios.values.each do |horario_id|
      if(params[horario_id.to_s] == "1")
        Disponible.create(horario_id: horario_id, usuario_id: current_usuario.id)
      end
    end
    flash[:alert] = "Disponibilidad actualizada"
    redirect_to :action => "servicio_form"
  end

  def monitores
        year = params[:chosen_week].split('_')[0].to_i
        week = params[:chosen_week].split('_')[1].to_i
        servicio = params[:servicio_id]
        @week_start = Date.commercial( year, week, 1 )
        @horarios = Horario.get_week_ids(servicio, @week_start)
        @horas = Horario.get_week_hour_range(servicio, @week_start)
        disponibles = Disponible.get_monitores_week(servicio, @week_start)
        @monitores = {}
        horas = {}
        conflictos = []
        @horarios.values.each do |horario_id|
            if(disponibles[horario_id].nil?)
                @monitores[horario_id] = nil
            elsif(disponibles[horario_id].count == 1)
                usuario_id = disponibles[horario_id].first.usuario_id
                @monitores[horario_id] = disponibles[horario_id].first.usuario.name
                horas[usuario_id] = horas[usuario_id] ? horas[usuario_id]+1 : 1
            else
                conflictos.push(horario_id)
            end
        end
        conflictos.each do |horario_id|
            chosen_monitor = solve_conflict(horas, disponibles[horario_id])
            usuario_id = chosen_monitor.usuario_id
            @monitores[horario_id] = chosen_monitor.usuario.name
            horas[usuario_id] = horas[usuario_id] ? horas[usuario_id]+1 : 1
        end
    end

    private
    def solve_conflict(horas, monitores)
        chosen_monitor = monitores.first
        monitores.each do |monitor|
            if(horas[monitor.usuario_id] < horas[chosen_monitor.usuario_id])
                chosen_monitor = monitor
            end
        end
        return chosen_monitor
    end
end
