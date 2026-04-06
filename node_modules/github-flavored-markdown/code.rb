require 'digest/md5'

def gfm(text)
  # Extract pre blocks
  extractions = {}
  text.gsub!(%r{<pre>.*?</pre>}m) do |match|
    md5 = Digest::MD5.hexdigest(match)
    extractions[md5] = match
    "{gfm-extraction-#{md5}}"
  end

  # prevent foo_bar_baz from ending up with an italic word in the middle
  text.gsub!(/(^(?! {4}|\t)\w+_\w+_\w[\w_]*)/) do |x|
    x.gsub('_', '\_') if x.split('').sort.to_s[0..1] == '__'
  end

  # in very clear cases, let newlines become <br /> tags
  text.gsub!(/(\A|^$\n)(^\w[^\n]*\n)(^\w[^\n]*$)+/m) do |x|
    x.gsub(/^(.+)$/, "\\1  ")
  end

  # Insert pre block extractions
  text.gsub!(/\{gfm-extraction-([0-9a-f]{32})\}/) do
    extractions[$1]
  end

  text
end

if $0 == __FILE__
  require 'test/unit'
  require 'shoulda'

  class GFMTest < Test::Unit::TestCase
    context "GFM" do
      should "not touch single underscores inside words" do
        assert_equal "foo_bar", gfm("foo_bar")
      end

      should "not touch underscores in code blocks" do
        assert_equal "    foo_bar_baz", gfm("    foo_bar_baz")
      end

      should "not touch underscores in pre blocks" do
        assert_equal "<pre>\nfoo_bar_baz\n</pre>", gfm("<pre>\nfoo_bar_baz\n</pre>")
      end

      should "escape two or more underscores inside words" do
        assert_equal "foo\\_bar\\_baz", gfm("foo_bar_baz")
      end

      should "turn newlines into br tags in simple cases" do
        assert_equal "foo  \nbar  ", gfm("foo\nbar")
      end

      should "convert newlines in all groups" do
        assert_equal "apple  \npear  \norange\n\nruby  \npython  \nerlang",
                     gfm("apple\npear\norange\n\nruby\npython\nerlang")
      end

      should "not convert newlines in lists" do
        assert_equal "# foo\n# bar", gfm("# foo\n# bar")
        assert_equal "* foo\n* bar", gfm("* foo\n* bar")
      end
    end
  end
end