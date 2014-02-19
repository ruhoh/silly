module Silly
  class PageModel < SimpleDelegator
    class << self
      attr_accessor :before_data, :after_data, :before_content, :after_content
    end

    def data
      return {} unless file?

      data = Silly::Parse.page_file(realpath)["data"]
      data['id'] = id

      if self.class.before_data.respond_to?(:call)
        data = self.class.before_data.call(data)
      end

      filename_data = Silly::Parse.filename(id)
      data['title'] ||= filename_data['title']
      data['date'] = parse_date(data['date'] || filename_data['date'])
      data['_url'] = make_url(data)

      self.class.after_data.respond_to?(:call) ?
        self.class.after_data.call(data) :
        data
    end

    def content
      result = Silly::Parse.page_file(realpath)["content"]

      if self.class.before_content.respond_to?(:call)
        result = self.class.before_content.call(result)
      end

      self.class.before_content.respond_to?(:call) ?
        self.class.before_content.call(result) :
        result
    end

    private

    def make_url(data)
      page_data = data.dup
      format = page_data['permalink'] || "/:path/:filename"
      slug = Silly::UrlSlug.new(item: self, data: page_data, format: format)
      slug.generate
    end

    # Parse and store date as an object
    def parse_date(date)
      return date if (date.nil? || date.is_a?(Time))

      Time.parse(date)
    rescue
      raise(
        "ArgumentError: The date '#{ date }' specified in '#{ id }' is unparsable."
      )
    end

    # Is the item backed by a physical file in the filesystem?
    # @return[Boolean]
    def file?
      !!realpath
    end
  end
end
