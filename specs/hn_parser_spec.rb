require 'rspec'
require 'hn_parser'

HEADER_ONLY=<<EOF1
   [1][y18.gif] [2]Hacker News [s.gif] [3]new | [4]comments | [5]ask |
   [6]jobs | [7]submit [8]login
   1.
EOF1

SOME_STORIES=<<EOF1
   [1][y18.gif] [2]Hacker News [s.gif] [3]new | [4]comments | [5]ask |
   [6]jobs | [7]submit [8]login
   1.

                             [9][grayarrow.gif]

   [10]A practical use for space-filling curves (gatech.edu)
   36 points by [11]RiderOfGiraffes 2 hours ago | [12]10 comments
   2.

                             [13][grayarrow.gif]

   [14]The Solvers' Manifesto (solversmanifesto.com)
   7 points by [15]hugoahlberg 57 minutes ago | [16]1 comment
   3.

                             [17][grayarrow.gif]

   [18]Don't waste your time by cd-ing in the terminal (huyng.com)
   316 points by [19]siim 15 hours ago | [20]discuss
   4.

                             [21][grayarrow.gif]

   [22]What will happen to Bit.ly links when Gaddafi shuts down the
   Internet in Libya? (quora.com)
   53 points by [23]andre3k1 6 hours ago | [24]22 comments
   [s.gif]

          [130]Lists | [131]RSS | [132]Search | [133]Bookmarklet |
    [134]Guidelines | [135]FAQ | [136]News News | [137]Feature Requests |
                [138]Y Combinator | [139]Apply | [140]Library
       [s.gif] [141][hnsearch.png] [s.gif] [142]Analytics by Mixpanel

References

   1. http://ycombinator.com/
   2. http://news.ycombinator.com/news
   3. http://news.ycombinator.com/newest
   4. http://news.ycombinator.com/newcomments
   5. http://news.ycombinator.com/ask
   6. http://news.ycombinator.com/jobs
   7. http://news.ycombinator.com/submit
   8. http://news.ycombinator.com/x?fnid=WXdCmhQgPI
   9. http://news.ycombinator.com/vote?for=2238872&dir=up&whence=%6e%65%77%73
  10. http://www2.isye.gatech.edu/~jjb/mow/mow.html
  11. http://news.ycombinator.com/user?id=RiderOfGiraffes
  12. http://news.ycombinator.com/item?id=2238872
  13. http://news.ycombinator.com/vote?for=2238952&dir=up&whence=%6e%65%77%73
  14. http://www.solversmanifesto.com/
  15. http://news.ycombinator.com/user?id=hugoahlberg
  16. http://news.ycombinator.com/item?id=2238952
  17. http://news.ycombinator.com/vote?for=2237595&dir=up&whence=%6e%65%77%73
  18. http://www.huyng.com/archives/quick-bash-tip-directory-bookmarks/492/
  19. http://news.ycombinator.com/user?id=siim
  20. http://news.ycombinator.com/item?id=2237595
  21. http://news.ycombinator.com/vote?for=2238664&dir=up&whence=%6e%65%77%73
  22. http://www.quora.com/What-will-happen-to-http-bit-ly-links-when-Gaddafi-shuts-down-the-Internet-in-Libya-due-to-protests
EOF1

class MockStream
  def initialize
    @state = 0
  end
  def eof
    res = (@state != 0)
    @state = (@state + 1) % 4
    res
  end
  def readline
    "Excerpt excerpt"
  end
end

describe HnParser do
  it "should ignore the header" do
    tf = "/tmp/test1_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << HEADER_ONLY
    end
    File.open(tf, 'r') do |inf|
      hp = HnParser.new(inf)
      hp.parse_stories
      hp.stories.length.should == 0
    end
    File.unlink(tf)
  end

  it "should find the stories" do
    tf = "/tmp/test2_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << SOME_STORIES
    end
    hp = nil
    IO.stub(:popen).and_yield(MockStream.new)
    File.open(tf, 'r') do |inf|
      hp = HnParser.new(inf)
      hp.parse_stories
      hp.stories.length.should == 4
    end
    stories = hp.stories
    stories[0].link.should == "http://www2.isye.gatech.edu/~jjb/mow/mow.html"
    stories[0].description.should == "A practical use for space-filling curves"
    stories[0].points.should == 36
    stories[0].comments.should == 10
    stories[0].excerpt.should == "Excerpt excerpt"

    stories[1].link.should == "http://www.solversmanifesto.com/"
    stories[1].description.should == "The Solvers' Manifesto"
    stories[1].points.should == 7
    stories[1].comments.should == 1
    stories[1].excerpt.should == "Excerpt excerpt"

    stories[2].link.should == "http://www.huyng.com/archives/quick-bash-tip-directory-bookmarks/492/"
    stories[2].description.should == "Don't waste your time by cd-ing in the terminal"
    stories[2].points.should == 316
    stories[2].comments.should == 0
    stories[2].excerpt.should == "Excerpt excerpt"

    stories[3].link.should == "http://www.quora.com/What-will-happen-to-http-bit-ly-links-when-Gaddafi-shuts-down-the-Internet-in-Libya-due-to-protests"
    stories[3].description.should == "What will happen to Bit.ly links when Gaddafi shuts down the Internet in Libya?"
    stories[3].points.should == 53
    stories[3].comments.should == 22
    stories[3].excerpt.should == "Excerpt excerpt"
    File.unlink(tf)
  end
end
