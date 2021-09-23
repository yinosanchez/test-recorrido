# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

recorrido = Servicio.new({ name: 'Recorrido', email: 'recorrido@recorrido.cl', password: 'password'})
recorrido.save!

alberto = Usuario.new({name: 'Alberto', email: 'alberto@recorrido.cl', password: 'password'})
alberto.save!

benito = Usuario.new({name: 'Benito', email: 'benito@recorrido.cl', password: 'password'})
benito.save!

carola = Usuario.new({name: 'Carola', email: 'carola@recorrido.cl', password: 'password'})
carola.save!

(8..18).each do |hour|
	(0..6).each do |weekday|
		Horario.create(servicio: recorrido, fecha: '2021-09-27'.to_date + weekday.days, hora: hour)
	end
end