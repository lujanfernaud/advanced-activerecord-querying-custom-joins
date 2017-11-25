class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
  belongs_to :manager, class_name: "Person", foreign_key: :manager_id
  has_many :employees, class_name: "Person", foreign_key: :manager_id

  def self.without_remote_manager
    left_joins(:manager).where(manager_is_null_or_has_local_manager)
  end

  def self.manager_is_null_or_has_local_manager
    "people.manager_id IS NULL
     OR people.location_id = managers_people.location_id"
  end

  def self.with_employees
    from(Person.
      joins(:employees).
      distinct, :people)
  end

  def self.with_local_coworkers
    from(Person.
      joins(location: :people).
      where("people_locations.id <> people.id").
      distinct, :people)
  end

  def self.order_by_location_name
    joins(:location).order("locations.name")
  end
end
