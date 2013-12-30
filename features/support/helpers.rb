SampleSitePath = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '__tmp'))

def query
  @query ||= new_query
end

def new_query
  query = Silly::Query.new
  query.append_path(SampleSitePath)
  query
end

def make_config(data)
  path = File.join(SampleSitePath, "config.yml")
  File.open(path, "w+") { |file|
    file.puts data.to_yaml
  }
end

def make_file(opts)
  path = File.join(SampleSitePath, opts[:path])
  FileUtils.mkdir_p(File.dirname(path))

  data = opts[:data] || {}
  if data['categories']
    data['categories'] = data['categories'].to_s.split(',').map(&:strip)
  end
  if data['tags']
    data['tags'] = data['tags'].to_s.split(',').map(&:strip)
    puts "tags #{data['tags']}"
  end
  data.delete('layout') if data['layout'].to_s.strip.empty?

  metadata = data.empty? ? '' : data.to_yaml.to_s + "\n---\n"

  File.open(path, "w+") { |file|
    if metadata.empty?
      file.puts <<-TEXT
#{ opts[:body] }
TEXT
    else
      file.puts <<-TEXT
#{ metadata }

#{ opts[:body] }
TEXT
    end
  }
end

Before do
  remove_instance_variable(:@query) if (instance_variable_defined?(:@query))
  FileUtils.remove_dir(SampleSitePath,1) if Dir.exists? SampleSitePath
  Dir.mkdir SampleSitePath
end

After do
  FileUtils.remove_dir(SampleSitePath,1) if Dir.exists? SampleSitePath
end
