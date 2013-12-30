module Silly
  module Utils
    # Merges hash with another hash, recursively.
    #
    # Adapted from Jekyll which got it from some gem whose link is now broken.
    # Thanks to whoever made it.
    def self.deep_merge(hash1, hash2)
      target = hash1.dup

      hash2.keys.each do |key|
        if hash2[key].is_a?(Hash) && hash1[key].is_a?(Hash)
          target[key] = deep_merge(target[key], hash2[key])
          next
        end

        target[key] = hash2[key]
      end

      target
    end
  end
end
