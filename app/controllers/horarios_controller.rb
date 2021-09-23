class HorariosController < ApplicationController
    before_action :authenticate_servicio!
    layout false, only: [:week_form, :monitores, :copy_past_week]

    def weeks
        @weeks = {}
        start_date = Horario.period_start(current_servicio)
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

    def week_form
        year = params[:chosen_week].split('_')[0].to_i
        week = params[:chosen_week].split('_')[1].to_i
        @week_start = Date.commercial( year, week, 1 )
        @horarios = Horario.get_week(current_servicio.id, @week_start)
    end

    def update_week
        week_start = params['week_start']
        Horario.clear_week(current_servicio.id, week_start)
        (0..6).each do |weekday|
            (0..23).each do |hour|
                if (params[weekday.to_s+'_'+hour.to_s]=='1')
                    Horario.create({fecha: week_start.to_date + weekday.days, hora: hour, servicio: current_servicio})
                end
            end
        end
        flash[:alert] = "Servicio Actualizado"
        redirect_to :action => "weeks"
    end

    def copy_past_week
        year = params[:chosen_week].split('_')[0].to_i
        week = params[:chosen_week].split('_')[1].to_i
        @week_start = Date.commercial( year, week, 1 )
        Horario.clear_week(current_servicio.id, @week_start)
        past_horarios = Horario.get_week_horarios(current_servicio.id, @week_start-7.days)
        puts past_horarios
        past_horarios.each do |horario|
            Horario.create({fecha: horario.fecha + 7.days, hora: horario.hora, servicio: current_servicio})
        end
        @horarios = Horario.get_week(current_servicio.id, @week_start)
        render :week_form
    end
end
