# encoding: UTF-8
Encoding.default_internal = 'UTF-8'

require 'json'
require 'time'
require 'fileutils'
require 'delegate'
require 'observer'
require 'set'
require 'cgi'

FileUtils.cd(path = File.join(File.dirname(__FILE__), 'silly')) do
  Dir[File.join('**', '*.rb')].each { |f| require File.join(path, f) }
end

module Silly
  FileSeparator = File::ALT_SEPARATOR ?
                    %r{#{ File::SEPARATOR }|#{ File::ALT_SEPARATOR.gsub('\\', '\\\\\\\\') }} :
                    File::SEPARATOR

  class Query
    include Enumerable
    attr_accessor :paths

    def initialize
      @criteria = {
        "path" => nil,
        "sort" => ["id", "asc"],
        "where" => [],
      }
      @paths = Set.new
    end

    def append_path(path)
      @paths << path
    end

    BlackList = ["", "~", "/"]
    def path(path)
      @criteria["path"] = BlackList.include?(path.to_s) ? "*" : File.join(path, "*")
      self
    end

    def path_all(path)
      @criteria["path"] = File.join(path, "**", "**")
      self
    end

    def sort(conditions=[])
      @criteria["sort"] = conditions
      self
    end

    def where(conditions)
      @criteria["where"] << conditions
      self
    end

    def each
      block_given? ?
        execute.each { |a| yield(a) } :
        execute
    end

    def execute
      @criteria["path"] ||= "*"
      puts "EXECUTE:\n #{ @criteria.inspect }"
      data = files(@criteria["path"])

      unless @criteria["where"].empty?
        data = data.keep_if { |id, pointer| filter_function(pointer) }
      end

      data = data.values.sort { |a,b| sorting_function(a,b) }

      Silly::Collection.new(data)
    end

    def list
      results = Set.new

      paths.each do |path|
        FileUtils.cd(path) {
          results += Dir['*'].select { |x| File.directory?(x) }
        }
      end

      results.to_a
    end

    def inspect
      "#{ self.class.name }\n criteria:\n #{ @criteria.inspect }"
    end

    private

    # Collect all files for the given @collection["path"].
    # Each item can have 3 file references, one per each cascade level.
    # The file hashes are collected in order so they will overwrite eachother.
    # but references to all found items on the cascade are recorded.
    # @return[Hash] dictionary of Items.
    def files(glob)
      dict = {}

      paths.each do |path|
        FileUtils.cd(path) {
          Dir[glob].each { |id|
            next unless File.exist?(id) && FileTest.file?(id)

            filename = id.gsub(Regexp.new("#{ File.extname(id) }$"), '')

            if dict[filename]
              dict[filename]["cascade"] << File.realpath(id)
            else
              dict[filename] = Silly::Item.new({
                "id" => id,
                "cascade" => [File.realpath(id)]
              })
            end
          }
        }
      end

      dict
    end

    FileAttributes = %{ id filename shortname directories ext }

    def filter_function(item)
      @criteria["where"].each do |condition|
        condition.each do |attribute_name, value|
          attribute_name = attribute_name.to_s
          attribute = attribute_name[0] == "$" ?
                        item.__send__(attribute_name[1, attribute_name.size]) :
                        item.data[attribute_name]

          valid = Silly::QueryOperators.execute(attribute, value)

          return false unless valid
        end
      end
    end

    def sorting_function(a, b)
      attribute = @criteria["sort"][0].to_s
      direction = @criteria["sort"][1].to_s

      # Optmization to omit parsing internal metadata when unecessary.
      if FileAttributes.include?(attribute)
        this_data = a.__send__(attribute)
        other_data = b.__send__(attribute)
      else
        this_data = a.data[attribute]
        other_data = b.data[attribute]
      end

      if attribute == "date"
        if this_data.nil? || other_data.nil?
          raise(
            "ArgumentError:" +
            " The query is sorting on 'date'" +
            " but '#{ this_data['id'] }' or '#{ other_data['id'] }' has no parseable date in its metadata." +
            " Add date: 'YYYY-MM-DD' to its metadata."
          )
        end
      end

      if direction == "asc"
        this_data <=> other_data
      else
        other_data <=> this_data
      end
    end
  end
end
