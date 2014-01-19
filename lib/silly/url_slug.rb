module Silly
  class UrlSlug
    @convertable_extensions = %w{ .md .markdown .mustache .haml .erb }
    class << self
      attr_reader :convertable_extensions

      def add_extensions(ext)
        if ext.is_a?(Array)
          @convertable_extensions += ext
        else
          @convertable_extensions << ext
        end
      end
    end

    def initialize(opts)
      @item = opts[:item]
      @scope =  @item.id.split('/').first
      @data = opts[:data]
      @format = opts[:format]

      parts = @item.id.split('/')
      parts.shift
      @scoped_id = parts.join('/')
    end

    # @return[String] URL Slug based on the given data and format.
    # The url should always have a preceeding slash "/some-url"
    def generate
      url = @format.include?(':') ? dynamic : literal
      url = process_url_extension(url)

      url.to_s.start_with?('/') ? url : "/#{ url }"
    end 

    # @return[String] the literal URL without token substitution.
    def literal
      @format.gsub(/^\//, '').split('/').map {|p| CGI::escape(p) }.join('/')
    end

    # @return[String] the dynamic URL with token substitution.
    def dynamic
      cache = data
      result = @format
                .gsub(/:[^\/\.]+/) { |a| cache[$&.gsub(':', '')] }
                .gsub('//', '/')
                .split('/')

      # this is ugly but I'm out of ideas. Help!
      last = result.pop
      if uses_extension?
        last = last
                .split('.')
                .map{ |a| Silly::StringFormat.clean_slug_and_escape(a) }
                .join('.')
      else
        last = Silly::StringFormat.clean_slug_and_escape(last)
      end

      result
        .map{ |a| Silly::StringFormat.clean_slug_and_escape(a) }
        .join('/') +
        "/#{ last }"
    end

    def data
      result = @data
      result = result.merge(date_data) if uses_date?

      result.merge({
        "filename"          => filename,
        "path"              => path,
        "relative_path"     => relative_path,
        "categories"        => category,
      })
    end

    def date_data
      date = Time.parse(@data['date'].to_s)

      {
        "year"       => date.strftime("%Y"),
        "month"      => date.strftime("%m"),
        "day"        => date.strftime("%d"),
        "i_day"      => date.strftime("%d").to_i.to_s,
        "i_month"    => date.strftime("%m").to_i.to_s,
      }
    rescue ArgumentError, TypeError
      raise(
        "ArgumentError:" +
        " The file '#{ @item.realpath }' has a permalink '#{ @format }'" +
        " which is date dependant but the date '#{ @data['date'] }' could not be parsed." +
        " Ensure the date's format is: 'YYYY-MM-DD'"
      )
    end

    def filename
      File.basename(@scoped_id, ext)
    end

    def ext
      @item.ext
    end

    # Category is only the first one if multiple categories exist.
    def category
      string = Array(@data['categories'])[0]
      return '' if string.to_s.empty?

      string.split('/').map { |c|
        Silly::StringFormat.clean_slug_and_escape(c)
      }.join('/')
    end

    def relative_path
      string = File.dirname(@scoped_id)
      (string == ".") ? "" : string
    end

    def path
      File.join(@scope, relative_path)
    end

    private

    def uses_date?
      result = false
      %w{ :year :month :day :i_day :i_month }.each do |token|
        if @format.include?(token)
          result = true
          break
        end
      end

      result
    end

    # Is an extension explicitly defined?
    def uses_extension?
      @format =~ /\.[^\.]+$/
    end

    # The url extension depends on multiple factors: 
    # user-config   : preserve any extension set by the user in the format.
    # converters    : Automatically change convertable extensions to .html
    #                 Non-convertable file-extensions should 'pass-through' 
    #
    # @return[String]
    def process_url_extension(url)
      return url if uses_extension?

      url += self.class.convertable_extensions.include?(ext) ? '.html' : ext

      url.gsub(/index|index.html$/, '').gsub(/\.html$/, '')
    end
  end
end
