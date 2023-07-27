# frozen_string_literal: true

require 'optparse'
require_relative 'weather_report_generator'

$options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby main.rb [options] <folder_path>"

  opts.on('-e', '--year YEAR', 'Specify the year for the weather report') do |year|
    $options[:year] = year.to_i
  end

  opts.on('-a', '--month MONTH', 'Specify the month for the average weather report (format: YYYY/M)') do |month|
    $options[:month] = Date.parse(month).strftime('%Y/%-m')
  end

  opts.on('-c', '--chart MONTH', 'Draw horizontal bar charts for the given month (format: YYYY/M)') do |month|
    $options[:chart] = Date.parse(month).strftime('%Y/%-m')
  end
end.parse!

if ARGV.empty?
  puts 'Error: Please provide the path to the folder containing weather data files.'
  puts "Usage: ruby main.rb [options] <folder_path>"
else
  folder_path = ARGV[0]

  if $options[:year]
    WeatherReportGenerator.generate_weather_report($options[:year], folder_path)
  end

  if $options[:month]
    year, month = $options[:month].split('/')
    WeatherReportGenerator.generate_monthly_weather_report(year.to_i, folder_path, month.to_i)
  end

  if $options[:chart]
    year, month = $options[:chart].split('/')
    WeatherReportGenerator.generate_monthly_weather_report(year.to_i, folder_path, month.to_i)
  end
end
