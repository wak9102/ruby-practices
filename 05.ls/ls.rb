#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'etc'

# aオプションがない場合の処理
def without_all(files)
  files.reject! { |f| /^\./.match?(f) }
end

# rオプションがある場合の処理
def reverse(files)
  files.reverse!
end

# lオプションがある場合の処理
def octal_file_mode_to_file_type_symbol(octal_file_mode)
  {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }[octal_file_mode.slice(0, 2)]
end

def octal_file_mode_to_file_permission_symbol(octal_file_mode)
  permission_symbols = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  <<~TEXT.chomp
    #{permission_symbols[octal_file_mode.slice(3)]}\
    #{permission_symbols[octal_file_mode.slice(4)]}\
    #{permission_symbols[octal_file_mode.slice(5)]}
  TEXT
end

def puts_with_long(files)
  block_size = files.each.sum { |file| File.stat(file).blocks }
  puts "total #{block_size}"

  files.each do |file|
    file_status = File::Stat.new(file)
    octal_file_mode = file_status.mode.to_s(8).rjust(6, '0')
    type = octal_file_mode_to_file_type_symbol(octal_file_mode)
    permission = octal_file_mode_to_file_permission_symbol(octal_file_mode)
    blocks = file_status.blocks
    user = Etc.getpwuid(file_status.uid).name
    group = Etc.getgrgid(file_status.gid).name
    size = file_status.size
    date = "#{file_status.mtime.mon.to_s.rjust(2)} #{file_status.mtime.day.to_s.rjust(2)}"
    time = file_status.mtime.strftime('%R')
    puts "#{type}#{permission}  #{blocks} #{user}  #{group}  #{size}  #{date} #{time} #{file}"
  end
end

# lオプションがない場合の処理
def puts_without_long(files)
  puts files
end

# コマンドラインオプションを配列で取得する
options = []
opts = OptionParser.new
opts.on('-a', '--all') { options << :all }
opts.on('-l') { options << :long }
opts.on('-r', '--reverse') { options << :reverse }
opts.parse!(ARGV)

# カレントディレクトリにあるファイルの一覧を配列で取得する
dir_path = Dir.getwd
files = []
Dir.foreach(dir_path) { |f| files << f }

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
