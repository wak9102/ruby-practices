#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  # コマンドラインオプションを配列に格納
  options = []
  opt = OptionParser.new
  opt.on('-l', '--lines') { options << :lines }
  opt.parse!(ARGV)

  # コマンドライン引数ごとのワードカウント結果を配列に格納
  # コマンドライン引数がない場合は標準入力を参照して結果を格納
  counted_results = if ARGV.any?
                      ARGV.map { |file| wc_count_file(file) }
                    else
                      Array.new([wc_count_stdin])
                    end

  # 引数が2つ以上ある場合は合計値も出力
  counted_results_print(counted_results, options)
  counted_results_total_print(counted_results, options) if ARGV.size >= 2
end

def wc_count_text(text)
  {
    line: text.count("\n"),
    word: text.scan(/\s+/).size,
    byte: text.bytesize
  }
end

def wc_count_file(file)
  counted_result = { name: file }
  file_text = File.open(file, 'r', &:read)
  counted_result.merge(wc_count_text(file_text))
end

def wc_count_stdin
  counted_result = { name: :stdin }
  stdin_text = $stdin.readlines.join
  counted_result.merge(wc_count_text(stdin_text))
end

def counted_results_print(counted_results, options)
  counted_results.each do |result|
    print result[:line].to_s.rjust(8)
    print result[:word].to_s.rjust(8) if options.none?(:lines)
    print result[:byte].to_s.rjust(8) if options.none?(:lines)
    print " #{result[:name]}" if result[:name] != :stdin
    print "\n"
  end
end

def counted_results_total_print(counted_results, options)
  print counted_results.sum { |result| result[:line] }.to_s.rjust(8)
  print counted_results.sum { |result| result[:word] }.to_s.rjust(8) if options.none?(:lines)
  print counted_results.sum { |result| result[:byte] }.to_s.rjust(8) if options.none?(:lines)
  print " total\n"
end

main
