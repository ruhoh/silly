module Silly
  class BaseModel < SimpleDelegator
    def process
      {
        "data" => {},
        "content" => File.open(realpath, 'r:UTF-8') { |f| f.read }
      }
    end
  end
end
