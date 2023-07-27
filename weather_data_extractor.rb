# frozen_string_literal: true

require 'date'

# weather_data_extractor.rb

module WeatherDataExtractor
  extend self

  def extract_year(date)
    Date.parse(date).year if date
  rescue ArgumentError
    nil
  end

  def extract_month(date)
    Date.parse(date).month if date
  rescue ArgumentError
    nil
  end
end

