#!/usr/bin/ruby

# Create new jekyll post and open in textmate
# $ ruby _new.rb This is the title

# The arguments form the title
unless ARGV[0]
  raise "Please provide a post title."
end

# Create a URL slug from the title
def slugify(title)
    str = title.dup
    str.gsub!(/[^a-zA-Z0-9 ]/,"")
    str.gsub!(/[ ]+/," ")
    str.gsub!(/ /,"-")
    str.downcase!
    str
end

# Create parameters
root   = "./"
title  = ARGV.join(' ')
slug   = slugify(title)
prefix = Time.now.strftime("%Y-%m-%d")
datetime = Time.now.strftime("%Y-%m-%d %H:%M:%S")
file   = "#{prefix}-#{slug}.md"
path   = File.join(root, "_posts/#{file}")
text   = <<-eos
---
title: #{title}
layout: post
date: #{datetime}
---

eos

# Create a new file and open it in textmate
File.open(path, 'w') { |f| f.write(text) }
#system("mate #{path}")
system("vi", path, "+6")
#system("git", "add", path)
