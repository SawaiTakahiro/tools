#! ruby -Ku

=begin
 2016/03/31
 よくつかうやつまとめ
=end

#共通の部分
#使うライブラリ
require "fileutils"
require "CSV"
require "json"

##########################################################################################
#CSVファイルを読み込んで、配列で返すやつ
#文字コードも変換しちゃう
def read_csv(file_path_csv)
	data_csv = CSV.read(file_path_csv, encoding: "Shift_JIS:UTF-8")
	
	return data_csv
end

#配列をCSVで保存する
def save_csv(array, save_path)
	CSV.open(save_path, "w") do |csv|
		array.each{|row| csv << row}
	end
end


#JSONを読んで、ハッシュで返すやつ
def read_json(path)
	data = open(path) do |io|
		JSON.load(io)
	end
	
	return data
end

#ハッシュをJSONで保存するやつ
def save_json(hash, save_path)
	open(save_path, "w") do |io|
		JSON.dump(hash, io)
	end
end


#半角数字にできそうなら、半角数字で返す
def zenkaku_to_hankaku(value)
	return 0 if value.nil?	#データが空白（完全に空なnil）の場合もある。0で戻しちゃう
	
	temp = value.tr("０-９", "0-9")
	
	if temp == nil then
		return value
		else
		return temp
	end
	
end

#この書き方、面白いから覚えておく
#rank = row[DATA_INDEX["rank"]].tr("０-９", "0-9")
#row[DATA_INDEX["rank"]] = rank if rank	#nilはfalseなので。nilじゃなければ〜

#全角か半角かチェック
#参考：http://cortyuming.hateblo.jp/entry/20140521/p1
def char_bytesize(char)
	char.bytesize == 1 ? 1 : 2
end


#Arrayクラスの拡張
#http://www.mk-mode.com/octopress/2014/11/04/ruby-correlation-coefficient/	より
class Array
	def r(y)
		# 以下の場合は例外スロー
		# - 引数の配列が Array クラスでない
		# - 自身配列が空
		# - 配列サイズが異なれば例外
		raise "Argument is not a Array class!"  unless y.class == Array
		raise "Self array is nil!"              if self.size == 0
		raise "Argument array size is invalid!" unless self.size == y.size
		
		# x の相加平均, y の相加平均 (arithmetic mean)
		mean_x = self.inject(0) { |s, a| s += a } / self.size.to_f
		mean_y = y.inject(0) { |s, a| s += a } / y.size.to_f
		
		# x と y の共分散の分子 (covariance)
		cov = self.zip(y).inject(0) { |s, a| s += (a[0] - mean_x) * (a[1] - mean_y) }
		
		# x の分散の分子, y の分散の分子 (variance)
		var_x = self.inject(0) { |s, a| s += (a - mean_x) ** 2 }
		var_y = y.inject(0) { |s, a| s += (a - mean_y) ** 2 }
		
		# 相関係数 (correlation coefficient)
		r = cov / Math.sqrt(var_x)
		r /= Math.sqrt(var_y)
	end
end




