require 'redmine'

Redmine::Plugin.register :redmine_videojs do
    name 'Redmine Video.js Plugin'
    author 'Robert Redl'
    description 'Embed videos into wiki pages using the HTML5 Video.js player.'
    url 'https://github.com/r5r3/redmine_videojs_pluigin'
    version '0.0.2'
end

# wiki macro for embedding videos
Redmine::WikiFormatting::Macros.register do
    macro :video do |o, args|
        # counter for video index
        @num ||= 0
        @num = @num + 1
        # find width and height
        for arg in args
            if arg.starts_with?("width=")
                width = arg[6..-1]
            end
            if arg.starts_with?("height=")
                width = arg[7..-1]
            end
        end
        # default is automatic
        width ||= "auto"
        height ||= "auto"
        # start html block for video
        out = "<div>\n"
        out += "<video id=\"video_#{@num}\" class=\"video-js vjs-default-skin\" controls preload=\"auto\" width=\"#{width}\" height=\"#{height}\" data-setup=\"{}\">\n"
        # find files in arguments
        accepted_formats = [".mp4", ".webm"]
        for arg in args
            if accepted_formats.include? File.extname(arg)
                attachment = o.attachments.find_by_filename(arg) if o.respond_to?('attachments')
                if attachment
                    file_url = url_for(:only_path => false, :controller => 'attachments', :action => 'download', :id => attachment, :filename => attachment.filename)
                else
                    file_url = arg.gsub(/<.*?>/, '').gsub(/&lt;.*&gt;/,'')
                end
                file_format = File.extname(arg)
                out += "<source src=\"#{file_url}\" type=\"video/#{file_format[1..-1]}\">\n"
            end
        end
        # finalize video html block
        out += "<p class=\"vjs-no-js\">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href=\"http://videojs.com/html5-video-support/\" target=\"_blank\">supports HTML5 video</a></p>\n"
        out += "</video>\n"
        out += "</div>\n"
        out.html_safe
    end
end

module RedmineVideojsPlugin
    class Hooks < Redmine::Hook::ViewListener
        # include video.js css and JavaScript files into the header
        def view_layouts_base_html_head(context={})
            tags = [stylesheet_link_tag('https://vjs.zencdn.net/5.6.0/video-js.css')]
            tags << javascript_include_tag('https://vjs.zencdn.net/ie8/1.1.1/videojs-ie8.min.js')
            tags << javascript_include_tag('https://vjs.zencdn.net/5.6.0/video.min.js')
            return tags.join(' ')
        end
    end
end
