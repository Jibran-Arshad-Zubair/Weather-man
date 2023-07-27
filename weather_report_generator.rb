# frozen_string_literal: true

require 'colorize'
require_relative 'weather_data_extractor'
require 'csv'

# Module for generating weather reports
module WeatherReportGenerator
  extend WeatherDataExtractor

  def self.read_weather_data(filename)
    data = CSV.read(filename, headers: true, skip_blanks: true)
    data_hash = data.map(&:to_h)
    data_hash.pop
    data_hash
  end

  def self.generate_weather_report(year, folder_path)
    year_report = []
    Dir.glob(File.join(folder_path, '*.txt')).each do |file_path|
      year_report.concat(read_weather_data(file_path))
    end
    max_temp = []
    min_temp = []
    max_humidity = []
    year_report.each do |row|
      max_temp.push(row['Max TemperatureC'].to_i) if row.key?('Max TemperatureC')
      min_temp.push(row['Min TemperatureC'].to_i) if row.key?('Min TemperatureC')
      max_humidity.push(row['Max Humidity'].to_i) if row.key?('Max Humidity')
    end
    highest_temp = max_temp.max
    lowest_temp = min_temp.min
    highest_humidity = max_humidity.max

    temp_date1 = find_date(year_report, 'Max TemperatureC', highest_temp)
    temp_date2 = find_date(year_report, 'Min TemperatureC', lowest_temp)
    humid_date = find_date(year_report, 'Max Humidity', highest_humidity)

    puts "Highest: #{highest_temp}°C on #{temp_date1}"
    puts "Lowest: #{lowest_temp}°C on #{temp_date2}"
    puts "Humid: #{highest_humidity}% on #{humid_date}"
  end

  def self.find_date(year_report, attribute, value)
    year_report.find { |row| row[attribute].to_i == value }['PKT']
  end
  def self.date?(element)
    return false unless element.is_a?(String)

    Date.parse(element) rescue false
  end

  def self.generate_monthly_weather_report(year, folder_path, month)
    highest_temps = {}
    lowest_temps = {}
    total_highest_temp = 0
    total_lowest_temp = 0
    total_humidity = 0
    total_days = 0
    year_report = []
    year_report.concat(read_weather_data(folder_path))
    max_temp = []
    min_temp = []
    max_humidity = []
    year_report.each do |row|
      max_temp.push(row['Max TemperatureC'].to_i) if row.key?('Max TemperatureC')
      min_temp.push(row['Min TemperatureC'].to_i) if row.key?('Min TemperatureC')
      max_humidity.push(row['Max Humidity'].to_i) if row.key?('Max Humidity')
    end
    highest_average = max_temp.sum/max_temp.size
    lowest_average = min_temp.sum/min_temp.size
    average_humidity = max_humidity.sum/max_humidity.size

    if $options[:month]
      puts "Highest Average: #{highest_average.round(1)}°C"
      puts "Lowest Average: #{lowest_average.round(1)}°C"
      puts "Average Humidity: #{average_humidity.round(0)}%"
    end

    if $options[:chart]
      puts "#{Date::MONTHNAMES[month]} #{year}"
      year_report.each do |day|
        date = Date.parse(day['PKT']) if date?(day['PKT'])
        if date
          day_num = date.day
          highest_temp_value = day['Max TemperatureC'] ? day['Max TemperatureC'].to_i : 0
          lowest_temp_value = day['Min TemperatureC'] ? day['Min TemperatureC'].to_i : 0
          puts "#{day_num.to_s.rjust(2)} " + ('+'.colorize(:red) * highest_temp_value) + " #{highest_temp_value}°C"
          puts "#{day_num.to_s.rjust(2)} " + ('+'.colorize(:blue) * lowest_temp_value) + " #{lowest_temp_value}°C"
        end
      end
    end
  end
end
