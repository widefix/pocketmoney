# frozen_string_literal: true

require 'matrix'

#  linear approximation of account balance change
class BalanceChangeApproximation
  def initialize(account)
    @account = account
    @data = @account.accumulative_balance_data
  end

  def self.call(...)
    new(...).execute
  end

  # obtaining coefficients of a linear approximation equation
  def execute
    return nil unless @data.length > 5

    n = day_passed
    matrix_a = Matrix[[sum_xx, sum_x], [sum_x, n]]
    matrix_b = Matrix.column_vector([sum_xy, sum_y])
    return nil unless matrix_a.det != 0

    matrix_a_inversed = matrix_a.inverse
    matrix_x = matrix_a_inversed * matrix_b

    # return coefficients a and b
    [matrix_x[0, 0], matrix_x[1, 0]]
  end

  def daily_balances
    return @daily_balances if @daily_balances

    daily_balances = []
    daily_balances[0] = 0
    start_date = @account.created_at.to_date
    end_date = Time.current.to_date
    current_balance = 0
    (start_date..end_date).each_with_index do |date, day|
      current_balance = @data[date.strftime('%Y-%m-%d')] if @data.key?(date.strftime('%Y-%m-%d'))
      daily_balances[day] = current_balance
    end
    @daily_balances = daily_balances
  end

  # elements of the equation matrix --
  def sum_x
    sum_of_progression(day_passed)
  end

  def sum_y
    daily_balances.sum
  end

  def sum_xx
    sum_of_squares_of_progression(day_passed)
  end

  def sum_xy
    (1..day_passed).reduce(0) { |sum, x| sum + (x * daily_balances[x - 1]) }
  end
  # --

  def day_passed
    @day_passed ||= (Time.current.to_date - @account.created_at.to_date).to_i + 1
  end

  def sum_of_progression(n)
    (n * (n + 1)) / 2
  end

  def sum_of_squares_of_progression(n)
    (n * (n + 1) * ((2 * n) + 1)) / 6
  end
end
