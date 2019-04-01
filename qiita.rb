require 'net/https'
require 'json'
require 'uri'
require "csv"

# 24回繰り返す。
24.times do
# tokennの位置作成したqiita tokenを記述してください
token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
# URI page1からpage15まで取得する
uri = URI.parse('https://qiita.com/api/v2/items?page=1&per_page=15')
http = Net::HTTP.new(uri.host, uri.port)

# セキュリティ系　指定
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# HTTPにリクエストをぶん投げる
req = Net::HTTP::Get.new(uri.request_uri)
req["Authorization"] = "Bearer #{token}"
    res = http.request(req)
    # JSONで帰ってきたbodyの値をparseしてやる
    a = JSON.parse res.body

    # 取得したデータを整形し、CSVファイルで出力する。
    CSV.open('qiita.csv','a') do |wcsv|
        wcsv << ["タイトル", "URL"]
        a.each do |qiita|
            wcsv << [qiita["title"],qiita["url"]]
        end
    end
    # 一度目の処理を終えたら１時間待機させる。
    sleep(3600)
end
