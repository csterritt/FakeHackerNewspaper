# Parse 'lynx --dump http://news.ycombinator.com/'
require 'arb_parser'

class HnStory
  def initialize(link, description, points, comments)
    @link = link
    @description = description
    @points = points
    @comments = comments
    @excerpt = ""
  end

  attr_accessor :link, :description, :points, :comments, :excerpt
end

class HnParser
  def initialize(stream)
    @stream = stream
    @stories = []
  end

  attr_reader :stories

  def remove_trailing_site(desc)
    if desc =~ /^(.*?)\(\S+\)$/
      desc = $1.strip
    end
    desc
  end

  def parse_stories
    @stories = []
    state = 0
    link = nil
    description = nil
    points = nil
    comments = nil
    refs = {}
    @stream.each_line do |line|
      # Story start
      if state == 0 && line =~ /grayarrow.gif/
        state = 1
      elsif state == 1 && line =~ /^\s*\[(\d+)\]\s*(\S.*)$/
        link = $1
        description = $2
        state = 2
      elsif state == 2 &&
          (line =~ /^\s*(\d+)\s*points.*\](\d+)\s*comment/ ||
              line =~ /^\s*(\d+)\s*points.*\]discuss/)
        points = $1
        comments = $2 || 0
        @stories << HnStory.new(link, remove_trailing_site(description), points.to_i, comments.to_i)
        state = 0
      elsif state == 2
        description += " " + line.strip
      elsif state == 0 && line =~ /^References/
        state = 3
      elsif state == 3 && line =~ /^\s*(\d+)\.\s*(http.*)$/
        refs[$1] = $2
      end
    end
    # Fix links, add excerpts
    @stories.each do |story|
      story.link = refs[story.link]
      IO.popen("/usr/local/bin/lynx --dump '#{story.link}'") do |stream|
        story.excerpt = ArbParser.new(stream).text
      end
    end
  end
end
