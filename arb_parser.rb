# Parse the human-readable bits from 'lynx --dump' output for arbitrary web sites

class ParagraphFinder
  def initialize(stream)
    @stream = stream
  end

  def likely_word_count(words)
    count = 0.0
    words.each do |word|
      count += 1.0 if word =~ /[a-zA-Z0-9]/
    end
    count
  end

  def too_many_long_words(words)
    count = 0
    words.each do |word|
      return true if word.length > 20
    end
    false
  end

  def interesting(poss)
    return false if poss.nil? || too_many_long_words(poss.split)
    parts = poss.split(/(\[\d+\])/)
    return true if parts.length == 1
    non_link = 0.0
    link = 0.0
    parts.each do |part|
      if part =~ /^\[\d+\]$/
        link += 1.0
      else
        words = part.split
        non_link += likely_word_count(words)
      end
    end
    (link < 4) && (non_link / link) >= 3.0
  end

  def next_paragraph
    res = nil
    in_paragraph = false
    while true
      possible = nil
      while !@stream.eof
        line = @stream.readline
        line = line.strip
        if line =~ /[a-zA-Z0-9]/
          in_paragraph = true
          if possible.nil?
            possible = ""
          else
            possible << " "
          end
          possible << line
        elsif in_paragraph && line == ""
          break
        end
      end
      if interesting(possible)
        res = possible.gsub(/\[\d+\]/, "").gsub(/\b_+\b/, "")
        break
      elsif @stream.eof
        break
      end
    end
    res
  end
end

class ArbParser
  def initialize(stream)
    finder = ParagraphFinder.new(stream)
    words = []
    next_paragraph = ""
    while words.length < 16 && next_paragraph != nil
      next_paragraph = finder.next_paragraph
      if next_paragraph != nil
        words.concat next_paragraph.split
      end
    end
    @text = words[0..14].join(" ")
  end

  def text
    @text
  end
end
