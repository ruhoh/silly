module Silly
  class Collection < SimpleDelegator
    attr_accessor :collection_name

    def initialize(data)
      super(data)
    end
  end
end
