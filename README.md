# Monitoring as a Service

## Instalacion

Para hacer funcionar este test. Se recomienda partir por correr las migraciones y el seed.

```
rails db:migrate
rails db:seed

```

Esto creara: 
- El servicio con el mail: recorrido@recorrido.cl y la contraseña 'password'.
- Tres usuarios:
	- alberto@recorrido.cl con contraseña 'password'
	- benito@recorrido.cl con contraseña 'password'
	- carola@recorrido.cl con contraseña 'password'
- La primera semana de horarios. Ninguno de los usuarios ha marcado su disponibilidad.

### Servicio

El usuario de servicio parte con una semana ya rellenada para decir cuando necesita monitoreo. Puede copiar los horarios necesario a otra semana para no tener que rellenar todas las casillas de nuevo. 

## Monitores

El monitor puede elegir el servicio y posteriormente la semana a vislumbrar. Luego puede editar su disponibilidad.
