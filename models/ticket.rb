require_relative('../db/sql_runner')

class Ticket

  attr_reader :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @id = options['id'] if options['id']
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    SqlRunner.run(sql)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values)[0]
    @id = ticket['id'].to_i
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

end
