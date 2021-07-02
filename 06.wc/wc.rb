#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  # コマンドラインオプションを配列に格納
  options = []
  opt = OptionParser.new
  opt.on('-l', '--lines') { options << :lines }
  opt.parse!(ARGV)

  # コマンドライン引数を配列に格納
  arg_files = ARGV

  # ファイルごとのワードカウント結果を配列に格納
  counted_results = []

  if arg_files.size.positive?
    arg_files.each do |file|
      counted_result = { name: file }
      file_text = File.open(file, 'r', &:read)
      counted_result.merge!(wc_count(file_text))
      counted_results << counted_result
    end
  else # 引数がない場合は標準入力を参照して結果を格納
    counted_result = { name: :stdin }
    stdin_text = $stdin.readlines.join
    counted_result.merge!(wc_count(stdin_text))
    counted_results << counted_result
  end

  # 結果を一つずつ出力
  counted_results.each do |result|
    print result[:line].to_s.rjust(8)
    unless options.include?(:lines)
      print result[:word].to_s.rjust(8)
      print result[:byte].to_s.rjust(8)
    end
    unless result[:name] == :stdin # 標準入力の結果にはファイル名を付与しない
      print " #{result[:name]}"
    end
    print "\n"
  end

  # 引数が2つ以上ある場合は合計値も出力
  if arg_files.size >= 2
    print counted_results.inject(0) { |sum, result| sum + result[:line] }.to_s.rjust(8)
    unless options.include?(:lines)
      print counted_results.inject(0) { |sum, result| sum + result[:word] }.to_s.rjust(8)
      print counted_results.inject(0) { |sum, result| sum + result[:byte] }.to_s.rjust(8)
    end
    print " total\n"
  end
end

# 文字列からline、word、byteをカウントするメソッド
def wc_count(text)
  {
    line: text.count("\n"),
    word: text.scan(/\s+/).size,
    byte: text.bytesize
  }
end

main
