require_relative('../db/sql_runner')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'] if options['id']
  end

  def self.all()
    sql = "SELECT * FROM customers"
    SqlRunner.run(sql)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.*
          FROM films
          INNER JOIN tickets
          ON films.id = tickets.film_id
          WHERE film_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map { |film| Film.new(film) }
  end

  def tickets_bought()
    sql = "SELECT *
          FROM tickets
          INNER JOIN customers
          ON customers.id = tickets.customer_id
          WHERE customers.id = $1
          ;"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    total = tickets.map { |ticket| Ticket.new(ticket) }
    return "#{@name} has bought #{total.count} tickets."
  end

  def buy_ticket(film, screening)
    if @funds >= film.price
      screening.sell_ticket(film)
      @funds -= film.price
      new_ticket = Ticket.new({'customer_id' => @id, 'film_id' => film.id, 'showing_time' => screening.showing_time})
      new_ticket.save
      self.update()
      return "#{@name} bought a ticket for #{film.title}. Total funds left are £#{@funds}."
    else
      return "#{@name} can't afford this!"
    end

  end

end
