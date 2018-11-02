require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

require('pry-byebug')

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({'name' => 'Jake', 'funds' => 10})
customer1.save()
customer2 = Customer.new({'name' => 'Hannah', 'funds' => 20})
customer2.save()

film1 = Film.new({'title' => 'Paddington', 'price' => 5, 'time_showing' => 1800})
film1.save()
film2 = Film.new({'title' => 'Mean Girls', 'price' => 15, 'time_showing' => 2015})
film2.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket2.save()
ticket3 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
ticket3.save()

screening1 = Screening.new({'film_title' => film1.title, 'film_showing_time' => film1.time_showing})
screening2 = Screening.new({'film_title' => film2.title, 'film_showing_time' => film2.time_showing})




binding.pry
nil
