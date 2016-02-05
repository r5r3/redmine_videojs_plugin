require 'redmine'

Redmine::Plugin.register :redmine_videojs do
    name 'Redmine Video.js Plugin'
    author 'Robert Redl'
    description 'Embed videos into wiki pages using the HTML5 Video.js player.'
    url 'https://github.com/r5r3/redmine_videojs_pluigin'
    version '0.0.1'
end

# wiki macro for embedding videos
Redmine::WikiFormatting::Macros.register do
    macro :video do |o, args|
        @width = args[1].gsub(/\D/,'') if args[1]
        @height = args[2].gsub(/\D/,'') if args[2]
        @width ||= 640
        @height ||= 480
        @num ||= 0
        @num = @num + 1
        attachment = o.attachments.find_by_filename(args[0]) if o.respond_to?('attachments')

        if attachment
            file_url = url_for(:only_path => false, :controller => 'attachments', :action => 'download', :id => attachment, :filename => attachment.filename)
        else
            file_url = args[0].gsub(/<.*?>/, '').gsub(/&lt;.*&gt;/,'')
        end
out = <<END
<div>
<video id="video_#{@num}" class="video-js vjs-default-skin" controls preload="auto" width="#{@width}" height="#{@height}" data-setup='{}'>
  <source src="#{file_url}" type="video/mp4">
</video>
<small>To view this video please enable JavaScript, and consider upgrading to a web browser
that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>.</small>
</div>
END
        out.html_safe
    end
end

module RedmineVideojsPlugin
    class Hooks < Redmine::Hook::ViewListener
        # include video.js css and JavaScript files into the header
        def view_layouts_base_html_head(context={})
            tags = [stylesheet_link_tag('http://vjs.zencdn.net/5.6.0/video-js.css')]
            tags << javascript_include_tag('http://vjs.zencdn.net/5.6.0/video.min.js')
            return tags.join(' ')
        end
    end
end
