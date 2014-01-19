module Silly
  class PageModel < SimpleDelegator
    DateMatcher = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/
    Matcher = /^(.+\/)*(.*)(\.[^.]+)$/

    def data
      return {} unless file?

      data = Silly::Parse.page_file(realpath)["data"]
      data['id'] = id

      filename_data = parse_page_filename(id)
      data['title'] ||= filename_data['title']
      data['date'] = parse_date(data['date'] || filename_data['date'])

      data
    end

    def content
      Silly::Parse.page_file(realpath)["content"]
    end

    private

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

    def parse_page_filename(filename)
      data = *filename.match(DateMatcher)
      data = *filename.match(Matcher) if data.empty?
      return {} if data.empty?

      if filename =~ DateMatcher
        {
          "path" => data[1],
          "date" => data[2],
          "slug" => data[3],
          "title" => to_title(data[3]),
          "extension" => data[4]
        }
      else
        {
          "path" => data[1],
          "slug" => data[2],
          "title" => to_title(data[2]),
          "extension" => data[3]
        }
      end
    end

    # my-post-title ===> My Post Title
    def to_title(file_slug)
      if file_slug == 'index' && !id.index('/').nil?
        file_slug = id.split('/')[-2]
      end

      file_slug
    end
  end
end
