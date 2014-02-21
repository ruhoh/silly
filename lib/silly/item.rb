module Silly
  class Item
    include Observable
    attr_reader :pointer
    attr_accessor :data, :content, :collection

    # File attributes are special attributes that
    # may be queried by prepending a $ to the attribute name.
    # Example: where({ "$ext" => ".md" })
    FileAttributes = %w{
      id
      filename
      shortname
      ext
      relative_shortname
      directories
      binary?
      text?
      data?
    }

    def initialize(hash)
      @pointer = hash
    end

    def [](key)
      respond_to?(key) ? __send__(key) : nil
    end

    def id
      @pointer["id"]
    end

    def realpath
      @pointer["cascade"].last
    end

    def cascade
      @pointer["cascade"]
    end

    def filename
      File.basename(id)
    end

    def shortname
      File.basename(id, ext)
    end

    def relative_shortname
      @filename ||= id.gsub(Regexp.new("#{ ext }$"), '')
    end

    def ext
      File.extname(id)
    end

    def directories
      File.dirname(id).split(Silly::FileSeparator)
    end

    def data?
      %w{ .json .yaml .yml }.include?(ext)
    end

    def text?
      !!mime_types.find do |a|
        a.to_s.start_with?('text') || a.to_s == "application/json"
      end
    end

    def binary?
      !text?
    end

    # @returns[Hash Object] Top page metadata
    def data
      @data ||= (_model.data || {})
    end

    # @returns[String] Raw page content
    def content
      @content ||= (_model.content || "")
    end

    def mime_types
      MIME::Types.type_for(realpath)
    end

    private

    def _model
      return @_model if @_model

      klass = if data?
                Silly::DataModel
              elsif binary?
                Silly::BinaryModel
              else
                Silly::PageModel
              end

      @_model = klass.new(self)
    end
  end
end
