Rails.application.routes.draw do
  devise_for :servicios
  devise_for :usuarios
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'main#logins'

  #horarios
  get '/horarios/weeks', to: 'horarios#weeks'
  get '/horarios/week_form/:chosen_week', to: 'horarios#week_form'
  get '/horarios/monitores/:chosen_week', to: 'horarios#monitores'
  post '/horarios/update_week', to: 'horarios#update_week'
  post '/horarios/copy_past_week', to: 'horarios#copy_past_week'

  #disponibles
  get '/disponibles/servicio_form', to: 'disponibles#servicio_form'
  get '/disponibles/week_form/:servicio_id', to: 'disponibles#week_form'
  get '/disponibles/disponibilidad/:servicio_id/:chosen_week', to: 'disponibles#disponibilidad'
  post '/disponibles/update_disponibilidad', to: 'disponibles#update_disponibilidad'
end
