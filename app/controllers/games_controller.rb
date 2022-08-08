# Some Description
class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    word = params[:word]
    start = params[:start_time_token].to_datetime
    finish = Time.now
    grid = params[:grid_token]
    @result = { time: finish - start, score: 0 }
    if word_api_check(word)['found'] && word_match_grid?(word, grid)
      @result[:message] = "Congratulations #{word.upcase} is a valid english word"
      @result[:score] = grid.size - (finish - start).ceil
    elsif !word_api_check(word)['found']
      @result[:message] = "Sorry but #{word.upcase} does not seem to be a valid english word..."
    else
      @result[:message] = "Sorry but #{word.upcase} can\'t built out of #{grid.upcase}"
    end
  end

  private

  def word_api_check(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    JSON.parse(response)
  end

  def word_match_grid?(word, grid)
    attempt = word.clone
    grid.split.each { |letter| attempt.sub!(letter, '') if attempt.include?(letter) }
    attempt == ''
  end

  def generate_grid
    grid = []
    10.times { grid << ('a'..'z').to_a.sample }
    grid
  end
end
