class Servicio < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  def self.list_for_form
    Servicio.all.map { |servicio| [servicio.id, servicio.name] }
  end
end
