module Silly
  class DataModel < SimpleDelegator
    def data
      data = {}
      cascade.each do |path|
        data = Silly::Utils.deep_merge(data, (Silly::Parse.data_file(path) || {}))
      end

      data
    end

    def content
      Silly::Parse.page_file(realpath)
    end
  end
end
