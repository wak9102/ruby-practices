#!/usr/bin/env ruby

require 'optparse'

# メソッド：テキストのline、word、byteをカウント
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

# 引数のファイル情報を配列に格納
counted_results = []
counted_result_original = {}

if  arg_files.size > 0
  arg_files.each do |file|
    counted_result = counted_result_original.dup
    counted_result[:name] = file
    text = File.open(file, "r") { |f| f.read }
    counted_result.merge!(wc_count(text))
    counted_results << counted_result
  end
else # コマンドライン引数がない場合は標準入力を参照
  counted_result = counted_result_original.dup
  counted_result[:name] = :stdin
  text = $stdin.readlines.join
  counted_result.merge!(wc_count(text))
  counted_results << counted_result
end
















