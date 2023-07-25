module VideosHelper
  def find_youtube_url(youtube_url)
    if youtube_url.match?(%r{^(https?://)?(www\.)?(youtu\.be/|youtube\.com/watch\?v=)([\w-]+)(\S+)?$})
      extracted_url = youtube_url.strip.gsub(%r{^(https?://)?(www\.)?(youtu\.be/|youtube\.com/watch\?v=)}, "")
      extracted_url.gsub!(/\?t=(\d+)s?/, "?start=\\1&enablejsapi=1") # t=数字部分を?start=の後に置換
      extracted_url
    end
  end
end
