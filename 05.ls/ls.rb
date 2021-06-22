#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"

# aオプションがない場合の処理
def no_all(array)
array.reject! { |f| /^\./ === f }
end

# コマンドラインオプションを配列で取得する
options = []
opts = OptionParser.new
opts.on("-a","--all") {options << :all}
opts.on("-l") {options << :long}
opts.on("-r","--reverse") {options << :reverse}
opts.parse!(ARGV)

# カレントディレクトリにあるファイルの一覧を配列で取得する
dir_path = Dir.getwd
files = []
Dir.foreach(dir_path){|f| files << f}

# aオプションがなければドットファイルを削除する
no_all(files) unless options.include?(:all)

# rオプションがあれば降順にソートする
files.sort!
files.reverse! if options.include?(:reverse)

puts files
