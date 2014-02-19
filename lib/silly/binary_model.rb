module Silly
  class BinaryModel < SimpleDelegator
    def data
      #TODO: Need to include data["_url"] or i suspect urls for binary files will break
      Silly::Parse.filename(id)
    end

    def content
      ''
    end
  end
end
