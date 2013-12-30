[![Build Status](https://travis-ci.org/ruhoh/silly.png?branch=master)](https://travis-ci.org/ruhoh/silly)

Silly is a filesystem based Object Document Mapper.  
Use it to query a directory like you would a database -- useful for static websites.

## Installation

Silly is in alpha which means the API is unstable and still under development. Silly is/will-be used to power [ruhoh](http://ruhoh.com) 3.0. You can contribute and help stablize Silly by playing with it and providing feedback!

Install and run the development (head) version:

    $ git@github.com:ruhoh/silly.git

Take note of where you downloaded the gem.

Navigate to a directory you want to query.

Create a file named `Gemfile` with the contents:

    gem 'silly', :path => '/Users/jade/Dropbox/gems/silly'

Make sure to replace the path with where you downloaded the gem.

Install the bundle:

    $ bundle install

## Usage

We can test the query API by loading an irb session loading Silly:

Load irb:

    $ bundle exec irb

Load and instantiate silly relative to the current directory:

    > require 'silly'
    > query = Silly::Query.new
    > query.append_path(Dir.pwd)


## Data

### Cascade

Append an arbitrary number of paths to enable a logical cascade where files overload one another of the same name.

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)
query.append_path(File.join(Dir.pwd, "theme-folder"))
```

### Data Files

Data files are automatically parsed and merged down the cascade:

    Given:
      ./data.yml
      ./theme-folder/data.json

    query = Silly::Query.new
    query.append_path(Dir.pwd)
    query.append_path("theme-folder")

    query.where("$shortname" => "data").first

### File metadata

Files have inherit metadata such as path, filename, extension etc.
Files can also define arbitrary in-file "top metadata" or FrontMatter made popular by static site generators like Jekyll.

**page.html**

    ---
    title: "A custom title"
    date: "2013/12/12"
    tags: 
      - opinion
      - tech
    ---

    ... content ...


## Query API

All queries return a [Silly::Collection](https://github.com/ruhoh/silly/blob/master/lib/silly/collection.rb) of [Silly::Item](https://github.com/ruhoh/silly/blob/master/lib/silly/item.rb)s.

`Silly::Item` represents a file. 

`@item.data` lazily generates any metadata in the file.

`@item.content` lazily generates the raw content of the file.


### Path

**Return all files in the base directory (unnested)**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.to_a
```

**Return files in the base directory and all sub-directories.**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.path_all("").to_a 
```

### Filter

**Return files with specific extension**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.where("$ext" => ".md").to_a
```

**Return files contained in a given directory (can be any nesting level)**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.where("$directories" => "drafts").to_a
```

**Return files where an attribute is a given value**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.where("size" => "med").to_a
```

**Return files where an attribute is not a given value**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.where("size" => {"$ne" => "med"}).to_a
```

**Return files where an attribute exists**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.where("size" => {"$exists" => true}).to_a
```


### Sort

**Return files sorted by a given attribute**

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query.sort([:date, :desc]).to_a
```


### Chaining

```ruby
query = Silly::Query.new
query.append_path(Dir.pwd)

query
  .path("posts")
  .where("$directories" => { "drafts" => { "$ne" => "drafts" } })
  .sort([:date, :desc])
  .to_a
```

## Why

Silly has no dependencies so it's a great engine to build custom static site generators on top of.

I really like the idea of a static website generator but it's really hard to get people to adopt your philosphy of how thing's should work so rather than do that why not empower anyone to build a static generator however they want! That's the idea anyway and this is a very early release so we'll see.
Also I am really inspired by projects like [Tire](https://github.com/karmi/retire) and [Mongoid](https://github.com/mongoid/mongoid) of which I've taken heavy inspiration from. Silly is a way to level up my gem skills B).

## License 

[MIT](http://www.opensource.org/licenses/mit-license.html)
