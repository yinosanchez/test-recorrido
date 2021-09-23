class MainController < ApplicationController
	def logins
		if servicio_signed_in?
			redirect_to :controller => 'horarios', :action => 'weeks'
		elsif usuario_signed_in?
			redirect_to :controller => 'disponibles', :action => 'servicio_form'
		end		
	end
end
