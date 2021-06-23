#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"

# aオプションがない場合の処理
def without_all(files)
  files.reject! { |f| /^\./ === f }
end

# rオプションがある場合の処理
def reverse(files)
  files.reverse!
end

# lオプションがある場合の処理
def puts_with_long(files)
  puts files
end

# lオプションがない場合の処理
def puts_without_long(files)
  puts files
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
without_all(files) unless options.include?(:all)

# rオプションがあれば降順にソートする
files.sort!
reverse(files) if options.include?(:reverse)

# lオプションがあればロングフォーマットで出力する
if options.include?(:long)
  puts_with_long(files)
else
  puts_without_long(files)
end


