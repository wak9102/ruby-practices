#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

# コマンドラインのオプションと引数を解析する
opt = OptionParser.new
params = {}

opt.on('-y [YEAR(1970~2100)]') { |v| params[:y] = v }
opt.on('-m [MONTH(1~12)]') { |v| params[:m] = v }

begin
  opt.parse(ARGV)
rescue StandardError => e
  e
end

# 解析結果から表示する年月を決定する
year = params[:y].to_i
month = params[:m].to_i

year = Date.today.year unless year >= 1970 && year <= 2100
month = Date.today.mon unless month >= 1 && month <= 12

# カレンダーを表示する
first_date = Date.new(year, month, 1)
last_day = Date.new(year, month, -1).day
line_break = 0

puts first_date.strftime('%-m月 %Y').center(20)
puts '日 月 火 水 木 金 土'
print '   ' * first_date.wday

(1..last_day).each do |day|
  if Date.new(year, month, day).jd == Date.today.jd
    print "\e[7m#{day.to_s.rjust(2)}\e[0m "
  else
    print "#{day.to_s.rjust(2)} "
  end

  if Date.new(year, month, day).wday == 6
    puts "\n"
    line_break += 1
  end
end

puts "\n" * (6 - line_break)
