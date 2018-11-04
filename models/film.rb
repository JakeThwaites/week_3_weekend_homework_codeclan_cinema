require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'] if options['id']
  end

  def self.all()
    sql = "SELECT * FROM films"
    SqlRunner.run(sql)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values)[0]
    @id = film['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.*
  FROM customers
  INNER JOIN tickets
  ON customers.id = tickets.customer_id
  WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map { |customer| Customer.new(customer) }
  end

  def total_customers()
    sql = "SELECT *
          FROM tickets
          INNER JOIN films
          ON films.id = tickets.film_id
          WHERE films.id = $1
          ;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    total = customers.map { |customer| Customer.new(customer) }
    return total.count
  end

  def most_popular_viewing_time()
    sql = "SELECT showing_time
          FROM tickets
          INNER JOIN films
          ON films.id = tickets.film_id
          WHERE films.id = $1"
    values = [@id]
    viewing_times = SqlRunner.run(sql, values)
    all_times = viewing_times.map { |time| Ticket.new(time) }
    most_popular = all_times.max_by{ |time| all_times.count(time) }
    return "The most popular viewing time is #{most_popular.showing_time}"
  end
end
