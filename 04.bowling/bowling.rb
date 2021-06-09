#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数のスコアを配列に格納する
scores = ARGV[0].split(',')

# スコアの配列の要素をint型にする
# ストライクは10に置換する
# 9フレーム目（17投目）までのストライクの次には0を追加する
shots = []

scores.each do |score|
  if score == 'X'
    shots << 10
    if shots.count <= 17
      shots << 0
    end
  else
    shots << score.to_i
  end
end

# スコアの配列をフレームごとの配列にする
# 1フレーム2投ずつ格納して11個目の要素があれば10個目にまとめる
frames = []

shots.each_slice(2) { |shot| frames << shot }
if frames[10]
  frames[9].push(*frames[10])
  frames.delete_at(10)
end

# フレームごとに得点を加算する
# 前フレームがスペアの場合は、1投目を2倍加算する
# 前フレームと前々フレームがストライクの場合は、1投目を3倍、2投目を2倍で加算する
# 前フレームだけがストライクの場合は、1投目を2倍、2投目を2倍で加算する

points = 0
spare_or_strike_last_time = nil # 前フレームがスペアかストライクだったかを格納
spare_or_strike_the_time_before_last = nil # 前々フレームがスペアかストライクだったかを格納

frames.each do |first, second|
  # 今回のフレームの得点を算出する
  case spare_or_strike_last_time
  when :spare then points += (first * 2 + second)
  when :strike
    points += if spare_or_strike_the_time_before_last == :strike
                (first * 3 + second * 2)
              else
                (first * 2 + second * 2)
              end
  else points += (first + second)
  end

  # スペアとストライクの状態を更新する
  spare_or_strike_the_time_before_last = spare_or_strike_last_time
  spare_or_strike_last_time = if first == 10
                                :strike
                              elsif first + second == 10
                                :spare
                              end
end

# 10フレーム目に3投目があれば加算する
points += frames[9][2] if frames[9][2]

puts points
