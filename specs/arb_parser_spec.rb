require 'rspec'
require 'arb_parser'

EXAMPLE1=<<EOF1
             Some combinatorial applications of spacefilling curves

   The spacefilling curve suggests a heuristic tour of a set of points

   Figure 1: A heuristic solution to the Traveling Salesman Problem is to
   visit the points in the same sequence as the Sierpinski spacefilling
   curve.


EOF1

EXAMPLE2=<<EOF2
   [1]Tweet

   IFRAME:
   [2]http://www.facebook.com/plugins/like.php?href=www.solversmanifesto.c
   om&layout=box_count&show_faces=false&width=60&action=like&colorscheme=l
   ight&height=65

The Solvers'
Manifesto

   by [3]Nuno Simaria | February 13^th 2011

   We, programmers that have learned how to combine fonts, shapes and
   colors so you could offer your client a professional looking interface.
EOF2

EXAMPLE3=<<EOF3
   #[1]Huy Nguyen <BB> Quick Bash Tip : Directory Bookmarks Comments Feed
   [2]Huy Nguyen [3]How to use chmod [4]How I Located a Camera in your
   Back Yard [5]Don't Hash Your Secrets, Here's why in Python [6]RSS

[7]Huy Nguyen

[8]Quick Bash Tip : Directory Bookmarks

Posted on September 10th, 2009

   EDIT 2010-07-01 : I've packaged up a shell script to allow you to save
   and jump to commonly used directories. It's called [9]bashmarks and it
EOF3

EXAMPLE4=<<EOF4
   #[1]Quora

   [2]Quora
     * [3]Home
     * [4]About
     * [5]Login
     * [6]Sign Up

   ____________________

   Similar questions will display as you type. If your question is
   available, choose it from the list.
     * [7]Search Questions, Topics and People Press enter to add a new
       question
EOF4

EXAMPLE5=<<EOF5
[1]New York Magazine

   Building Printer-Friendly Page...

   [2]Quantcast

References

   Visible links
   1. http://nymag.com/
   2. http://www.quantcast.com/p-52tlJ-QdbVwC-

   Hidden links:
   3. http://www.omniture.com/
EOF5

EXAMPLE6=<<EOF6
Excerpt excerpt
EOF6

EXAMPLE7=<<EOF7
   #[1]Economix � Why Does College Cost So Much? Comments Feed [2]Economix
   [3]Welcome to Economix [4]How Convincing Is the Case for Free Trade?
   [5]Podcast: Growth, the Deficit and the Elliott Wave [6]RSS 2.0

     * [7]Home Page
     * [8]Today's Paper
     * [9]Video
     * [10]Most Popular
     * [11]Times Topics

   [12][post&posall=TopAd,Bar1,Position1,Position1B,Top5,SponLink,MiddleRi
   ght,Box1,Box3,Bottom3,Right5A,Right6A,Right7A,Right8A,Middle1C,Bottom7,
   Bottom8,Bottom9,Inv1,Inv2,Inv3,CcolumnSS,Middle4,Left1B,Frame6A,Left2,L
   eft3,Left4,Left5,Left6,Left7,Left8,Left9,JMNow1,JMNow2,JMNow3,JMNow4,JM
   Now5,JMNow6,Feature1,Spon3,ADX_CLIENTSIDE,SponLink2&pos=Middle1C&query=
   qstring&keywords=?]
   Search All NYTimes.com ____________________ Search
   [13]New York Times

   ____________________
   Search
     * [30]Global
     * [31]DealBook
     * [32]Markets
     * [33]Economy
     * [34]Energy
     * [35]Media
     * [36]Personal Tech
     * [37]Small Business
     * [38]Your Money
     __________________________________________________________________

   February 18, 2011, 9:30 am

Why Does College Cost So Much?


    By [41]DAVID LEONHARDT

   [42]Book Chat

   Robert B. Archibald and David H. Feldman are economists at the College
EOF7

EXAMPLE8=<<EOF8
       Login ____________________
       Password ____________________
       Log in Log In
       Your login is either a username or an email address.
       [_] Keep me logged in. [40]Forgot your password?
       Share articles and comments with your friends
       Login with Facebook
       [41]What's This?
       You can connect your Facebook profile with WSJ.com to share
       articles, comments, and other activity with your friends.
EOF8

describe ParagraphFinder do
  it "should find no paragraphs in empty input" do
    tf = "/tmp/test1_#{$$}"
    File.open(tf, 'w') do |outf|
    end
    File.open(tf, 'r') do |inf|
      pf = ParagraphFinder.new(inf)
      pf.next_paragraph.should == nil
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE1" do
    tf = "/tmp/test1_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE1
    end
    File.open(tf, 'r') do |inf|
      pf = ParagraphFinder.new(inf)
      pf.next_paragraph.should == "Some combinatorial applications of spacefilling curves"
      pf.next_paragraph.should == "The spacefilling curve suggests a heuristic tour of a set of points"
      pf.next_paragraph.should == "Figure 1: A heuristic solution to the Traveling Salesman Problem is to visit the points in the same sequence as the Sierpinski spacefilling curve."
      pf.next_paragraph.should == nil
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE2" do
    tf = "/tmp/test2_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE2
    end
    File.open(tf, 'r') do |inf|
      pf = ParagraphFinder.new(inf)
      pf.next_paragraph.should == "The Solvers' Manifesto"
      pf.next_paragraph.should == "by Nuno Simaria | February 13^th 2011"
      pf.next_paragraph.should == "We, programmers that have learned how to combine fonts, shapes and colors so you could offer your client a professional looking interface."
      pf.next_paragraph.should == nil
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE3" do
    tf = "/tmp/test3_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE3
    end
    File.open(tf, 'r') do |inf|
      pf = ParagraphFinder.new(inf)
      pf.next_paragraph.should == "Quick Bash Tip : Directory Bookmarks"
      pf.next_paragraph.should == "Posted on September 10th, 2009"
      pf.next_paragraph.should == "EDIT 2010-07-01 : I've packaged up a shell script to allow you to save and jump to commonly used directories. It's called bashmarks and it"
      pf.next_paragraph.should == nil
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE4" do
    tf = "/tmp/test4_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE4
    end
    File.open(tf, 'r') do |inf|
      pf = ParagraphFinder.new(inf)
      pf.next_paragraph.should == "Similar questions will display as you type. If your question is available, choose it from the list. * Search Questions, Topics and People Press enter to add a new question"
      pf.next_paragraph.should == nil
    end
    File.unlink(tf)
  end
end

describe ArbParser do
  it "should deal with EXAMPLE1" do
    tf = "/tmp/test1_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE1
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "Some combinatorial applications of spacefilling curves The spacefilling curve suggests a heuristic tour of a"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE2" do
    tf = "/tmp/test2_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE2
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "The Solvers' Manifesto by Nuno Simaria | February 13^th 2011 We, programmers that have learned"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE3" do
    tf = "/tmp/test3_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE3
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "Quick Bash Tip : Directory Bookmarks Posted on September 10th, 2009 EDIT 2010-07-01 : I've"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE4" do
    tf = "/tmp/test4_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE4
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "Similar questions will display as you type. If your question is available, choose it from"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE5" do
    tf = "/tmp/test5_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE5
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "New York Magazine Building Printer-Friendly Page... References"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE6" do
    tf = "/tmp/test6_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE6
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "Excerpt excerpt"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE7" do
    tf = "/tmp/test7_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE7
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "February 18, 2011, 9:30 am Why Does College Cost So Much? By DAVID LEONHARDT Robert"
    end
    File.unlink(tf)
  end

  it "should deal with EXAMPLE8" do
    tf = "/tmp/test8_#{$$}"
    File.open(tf, 'w') do |outf|
      outf << EXAMPLE8
    end
    File.open(tf, 'r') do |inf|
      ap = ArbParser.new(inf)
      ap.text.should == "Login Password Log in Log In Your login is either a username or an email"
    end
    File.unlink(tf)
  end
end
