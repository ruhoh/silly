module Silly
  class BaseModel < SimpleDelegator
    def data
      {}
    end

    def content
      File.open(realpath, 'r:UTF-8') { |f| f.read }
    end
  end
end
