module PostsHelper

  def embed_video_links(content)
    doc = Nokogiri::HTML.fragment(content.body.to_s)

    doc.search('a').each do |a|
      url = a['href']
      youtube_pattern = /(?:http?s?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.?be)\/(?:watch\?v=)?([^&]+)/
      vimeo_pattern = /(?:http?s?:\/\/)?(?:www\.)?(?:vimeo\.com)\/?(.+)/

      if url =~ youtube_pattern
        video_id = url.split('v=')[1]
        ampersand_position = video_id.index('&')
        video_id = video_id[0..ampersand_position - 1] if ampersand_position
        iframe = "<div class='video-responsive'><iframe width='560' height='315' src='https://www.youtube.com/embed/#{video_id}' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe></div>"
        a.replace iframe
      elsif url =~ vimeo_pattern
        video_id = url.split('/')[3]
        iframe = "<div class='video-responsive'><iframe src='https://player.vimeo.com/video/#{video_id}' width='640' height='360' frameborder='0' allow='autoplay; fullscreen; picture-in-picture' allowfullscreen></iframe></div>"
        a.replace iframe
      end
    end

    doc.to_html.html_safe
  end

end
