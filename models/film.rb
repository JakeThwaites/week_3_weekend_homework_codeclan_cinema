require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price, :time_showing
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @time_showing = options['time_showing']
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
    sql = "INSERT INTO films (title, price, time_showing) VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @price, @time_showing]
    film = SqlRunner.run(sql, values)[0]
    @id = film['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE films SET (title, price, time_showing) = ($1, $2, $3) WHERE id = $4;"
    values = [@title, @price, @time_showing, @id]
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
end
