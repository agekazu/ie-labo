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

num=1
DMInfo=Twitter.direct_messages(count:1).to_s

#抽出した文字列DMInfoの内、"text"=>"の文字列を抽出
/"text"=>"/ =~DMInfo
#"text"=>"の後の文字列を抽出
iDMtext = $'
#不要な「"}>]」を除く
DMtext=iDMtext.sub("\"}>]","")

#DMtextを(半角OR全角)スペースまたは,ごとに分割し、各変数に格納
sub = DMtext.split(/\s|　|,/)[0]
dl = DMtext.split(/\s|　|,/)[1]
week = DMtext.split(/\s|　|,/)[2]
con =  DMtext.split(/\s|　|,/)[3]

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
days = (dlday - nowday).divmod(24*60*60)
hours = days[1].divmod(60*60) 
mins = hours[1].divmod(60) 

#残り時間整形
deadline = "#{days[0].to_i} 日 #{hours[0].to_i} 時間 #{mins[0].to_i} 分 " 

#実際にbotがつぶやく文章を整形
Word="教科名: " + sub + "     締切日: " + d_month + "月" + d_date + "日" + "(" + week + ")" +
	 "    内容: " + con + "     締切まであと" + deadline.to_s + "です。" 

#Wordを呟く
Twitter.update(Word)

