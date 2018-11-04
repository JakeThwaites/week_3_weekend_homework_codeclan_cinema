require_relative('../db/sql_runner')

class Screening

  attr_reader :film_title, :showing_time, :tickets_sold, :max_tickets_available, :id, :total_income

  def initialize(options)
    @film_title = options['film_title']
    @showing_time = options['showing_time']
    @tickets_sold = options['tickets_sold']
    @max_tickets_available = options['max_tickets_available']
    @id = options['id'] if options['id']
    @total_income = 0
  end

  def save()
    sql = "INSERT INTO screenings (film_title, showing_time, tickets_sold, max_tickets_available) values ($1, $2, $3, $4) RETURNING id"
    values = [@film_title, @showing_time, @tickets_sold, @max_tickets_available]
    SqlRunner.run(sql, values)
  end

  def tickets_available()
    @max_tickets_available > @tickets_sold
  end

  def sell_ticket(film)
    if tickets_available
      @tickets_sold += 1
      @total_income += film.price
    else
      p "There aren't any more tickets available."
      quit
    end
  end

end
