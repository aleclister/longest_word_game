require 'open-uri'
require 'json'

class PageController < ApplicationController
  def game
    @grid = generate_grid(9).join(" - ")
    @start_time = Time.now.to_f
    session[:nb_games] ? session[:nb_games] += 1 : session[:nb_games] = 1
  end

  def score
    start_time = params[:start_time]
    grid = params[:grid]
    end_time = Time.now.to_f
    attempt = params[:attempt]
    @output = run_game(attempt, grid, start_time, end_time)
    session[:aggr_score] ? session[:aggr_score] += @output[:score] : session[:aggr_score] = @output[:score]
    session[:avge_score] = session[:aggr_score].fdiv(session[:nb_games]).to_i
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def run_game(attempt, grid, start_time, end_time)
    output = { time: (end_time.to_i - start_time.to_i), translation: "", score: 100, message: "" }
    check(attempt, grid, output)
    # parse(attempt, output)
    unless output[:score] == 0
      output[:score] -= 5 * (5 - attempt.size) + 2 * output[:time]
      output[:message] = "Well done!"
      end
    return output
  end

  def check(attempt, grid, output)
    attempt.split("").each do |letter|
      if attempt.split("").count(letter) > grid.count(letter.upcase)
        output[:score] = 0
        output[:message] = "not in the grid"
      end
    end
  end
end