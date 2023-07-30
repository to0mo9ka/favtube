module PostCommentsHelper
  def linkify_comment(comment, video_id)
    escaped_comment = h(comment) # HTMLエスケープを行う

    # 再生時間の部分だけをエスケープ解除してリンクに変換
    escaped_comment.gsub!(time_regex) do |time|
      # 時間、分、秒を取得する
      time_parts = time.split(':').map(&:to_i)
      hours = time_parts.size == 3 ? time_parts[0] : 0
      minutes = time_parts[-2]
      seconds = time_parts[-1]

      time_in_seconds = hours * 3600 + minutes * 60 + seconds
      "<a href onclick=\"clickTime(#{time_in_seconds}); return false\">#{time}</a>"
    end

    # エスケープ解除されたコメントをHTMLエスケープして安全に表示
    escaped_comment.html_safe
  end

  private

  def time_regex
    /\b(?:\d{1,2}:)?\d{1,2}:\d{2}\b/
  end
end
