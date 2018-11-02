require_relative('../db/sql_runner')

class Screening

  attr_reader :film_title, :showing_time, :id

  def initialize(options)
    @film_title = options['film_title']
    @showing_time = options['showing_time']
    @id = options['id'] if options['id']
  end

  def save()
    sql = "INSERT INTO screenings (film_title, showing_time) values ($1, $2) RETURNING id"
    values = [@film_title, @showing_time]
    SqlRunner.run(sql, values)
  end

end
