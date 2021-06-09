#!/usr/bin/env ruby
# frozen_string_literal: true

# スコアを配列に格納する
scores = ARGV[0].split(',')

# スコア配列の要素をintにする
# ストライクの場合は10に置換する
shots = []
scores.each do |score|
  if score == 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

# スコア配列を2投ずつフレームごとの配列に格納する
frames = shots.each_slice(2)

# フレームごとにスコアを集計する
#   10フレーム以前は
#     前フレームがスペアの場合、1投目を2倍加算する
#     前フレームと前々フレームがストライクの場合、1投目を3倍、2投目を2倍加算する
#     前フレームだけストライクの場合、1投目を2倍、2投目を2倍加算する
#   11フレーム以降は
#     前フレームと前々フレームがストライクの場合、11フレームのみ1投目を2倍加算する
points = 0
spare_or_strike_last_time = nil # 前フレームがスペアかストライクかを格納する
spare_or_strike_the_time_before_last = nil # 前々フレームがスペアかストライクかを格納する

frames.each.with_index(1) do |shot, index|
  if index <= 10
    points += case spare_or_strike_last_time
              when :spare then (shot[0] * 2 + shot[1])
              when :strike
                if spare_or_strike_the_time_before_last == :strike
                  (shot[0] * 3 + shot[1] * 2)
                else
                  (shot[0] * 2 + shot[1] * 2)
                end
              else shot.sum
              end

    # スペアとストライクの状態を更新する
    spare_or_strike_the_time_before_last = spare_or_strike_last_time
    spare_or_strike_last_time = if shot[0] == 10
                                  :strike
                                elsif shot[0] + shot[1] == 10
                                  :spare
                                end

  elsif (index == 11) && (spare_or_strike_last_time == :strike) && (spare_or_strike_the_time_before_last == :strike)
    points += (shot[0] * 2 + shot[1])

  else
    points += shot.sum
  end
end

puts points
