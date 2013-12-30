module Silly
  class DataModel < SimpleDelegator
    def process
      data = {}
      cascade.each do |path|
        data = Silly::Utils.deep_merge(data, (Silly::Parse.data_file(path) || {}))
      end

      { 
        "data" => data,
        "content" => Silly::Parse.page_file(realpath)
      }
    end
  end
end
