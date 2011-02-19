# Parse the front page of Hacker News
require 'hn_parser'

`/usr/local/bin/lynx --dump 'http://news.ycombinator.com/' > latest.dump`
stream = IO.popen("cat latest.dump")
hnp = HnParser.new(stream)
stories = hnp.parse_stories
stories.each do |story|
  puts "Description: #{story.description}"
  puts "Link: #{story.link}"
  puts "Comments: #{story.comments}"
  puts "Points: #{story.points}"
  puts "Excerpt: #{story.excerpt}"
  puts "------------------"
end
