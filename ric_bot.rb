#encoding: utf-8

require 'rubygems'    # ←Ruby 1.9では不要 
require 'twitter'
require 'pp'

Twitter.configure do |config|
	config.consumer_key= "beIoy3ZKwxwpaRkjsTapsw"
	config.consumer_secret= "vK2IwokB0gtc1B5UqXGvS7HDlpa2xDJ3d3Dtg4CGzs"
	config.oauth_token="498604779-cDkCMkW2fdV89Mf4SfaECJF2AKZrLrjj4n8bnZ2k"
	config.oauth_token_secret="ZoRVUBGka8YLVup3LTTYeJ5MBx6U0GHSS40lDCQ5io"
end

num=10

#botがつぶやく言葉が格納される配列
words = Array.new
#ダイレクトメッセージのテキストが格納される配列
dmArray = Array.new
dmInfo=Twitter.direct_messages(count:num)

dmInfo.each do |dm|
	#dmArray先頭にdm.textを格納していく
	dmArray.unshift(dm.text)
	#puts dm.text
end


dmArray.each do |da|
#DMtextを(半角OR全角)スペースまたは,ごとに分割し、各変数に格納
sub = da.split(/\s|　|,/)[0]
dl = da.split(/\s|　|,/)[1]
week = da.split(/\s|　|,/)[2]
con =  da.split(/\s|　|,/)[3]

#dlを日時と時間に分ける
s = dl.unpack("a2"*(dl.length/2)) 
d_month = s[0] 
d_date = s[1]
d_hour = s[2]
d_minute = s[3]

#締切りのTimeオブジェクトを生成
dlday = Time.local(2012,d_month.to_i,d_date.to_i,d_hour.to_i,d_minute.to_i)

#今の時間
nowday = Time.new

#時間の差
#dlday < nowdayだった場合、daysは負になる
days = (dlday - nowday).divmod(24*60*60)
hours = days[1].divmod(60*60) 
mins = hours[1].divmod(60) 

#もし締切りが過ぎていなかったら
	if (days[0].to_i >= 0) then

		#残り時間整形
	deadline = "#{days[0].to_i} 日 #{hours[0].to_i} 時間 #{mins[0].to_i} 分 " 
#wordsに整形した文字列を格納
words.unshift("教科名: " + sub + "     締切日: " + d_month + "月" + d_date + "日" + "(" + week + ")" +
"    内容: " + con + "     締切まであと" + deadline.to_s + "です。") 
	end

end
#wordsの中の要素をつぶやく
words.each do |word|
	Twitter.update(word)
end


