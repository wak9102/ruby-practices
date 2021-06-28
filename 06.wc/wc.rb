#!/usr/bin/env ruby

require 'optparse'

# 文字列からline、word、byteをカウントするメソッド
def wc_count(text)
  {
    :line => text.count("\n"),
    :word => text.scan(/\s+/).size,
    :byte => text.bytesize
  }
end

# コマンドラインオプションを配列に格納
options = []
opt = OptionParser.new
opt.on('-l', '--lines') { options << :lines }
opt.parse!(ARGV)

# コマンドライン引数を配列に格納
arg_files = ARGV

# 引数のファイルごとのカウント結果をhashに格納し配列に追加
counted_results = []

if  arg_files.size > 0
  arg_files.each do |file|
    counted_result = Hash.new
    counted_result[:name] = file
    file_text = File.open(file, "r") { |f| f.read }
    counted_result.merge!(wc_count(file_text))
    counted_results << counted_result
  end
else # 引数がない場合は標準入力のカウント結果をhashに格納し配列に追加
  counted_result = Hash.new
  counted_result[:name] = :stdin
  stdin_text = $stdin.readlines.join
  counted_result.merge!(wc_count(stdin_text))
  counted_results << counted_result
end

# 要素ごとに結果を出力
counted_results.each do |result|
  print result[:line].to_s.rjust(8)
  print result[:word].to_s.rjust(8) unless options.include?(:line)
  print result[:byte].to_s.rjust(8) unless options.include?(:line)
  print " #{result[:name]}" unless result[:name] == :stdin
  print "\n"
end

# 引数が2つ以上ある場合はtotalも出力
if arg_files.size >= 2
  print counted_results.inject(0) { |sum, result| sum + result[:line] }.to_s.rjust(8)
  print counted_results.inject(0) { |sum, result| sum + result[:word] }.to_s.rjust(8) unless options.include?(:line)
  print counted_results.inject(0) { |sum, result| sum + result[:byte] }.to_s.rjust(8) unless options.include?(:line)
  print " total\n"
end

