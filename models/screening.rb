require_relative('../db/sql_runner')

class Screening

  attr_reader :film_title, :film_showing_time

  def initialize(options)
    @film_title = options['film_title']
    @film_showing_time = options['film_showing_time']
  end

end
