module Silly
  class PageModel < SimpleDelegator
    DateMatcher = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/
    Matcher = /^(.+\/)*(.*)(\.[^.]+)$/

    # Process this file. See #parse_page_file
    # @return[Hash] the processed data from the file.
    #   ex:
    #   { "content" => "..", "data" => { "key" => "value" } }
    def process
      return {} unless file?

      parsed_page = Silly::Parse.page_file(realpath)
      data = parsed_page['data']

      filename_data = parse_page_filename(id)

      data['pointer'] = pointer.dup
      data['id'] = id

      data['title'] = data['title'] || filename_data['title']
      data['date'] ||= filename_data['date']

      # Parse and store date as an object
      begin
        data['date'] = Time.parse(data['date']) unless data['date'].nil? || data['date'].is_a?(Time)
      rescue
        raise(
          "ArgumentError: The date '#{data['date']}' specified in '#{ id }' is unparsable."
        )
        data['date'] = nil
      end

      parsed_page['data'] = data

      parsed_page
    end

    private

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
