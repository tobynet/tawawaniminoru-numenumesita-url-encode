require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'
require 'pathname'

# refs http://d.hatena.ne.jp/rochefort/20110417/p1
describe "TawawaniminoruNumenumesitaUrlEncode" do
  before do
    @bigdata = YAML::load(Pathname(__FILE__).dirname.join('urls.yml').read)
  end

  def gekiteki?(&block)
    @bigdata.each do |x|
      block.call(x["before"], x["after"])
    end
  end

  def escape_for_uri(s)
    s.gsub(':', '%3A').gsub('/', '%2F').gsub('?', '%3F').gsub('=', '%3D').gsub('&', '%26')
  end

  it "CGI.escape" do
    require "cgi"
    gekiteki? do |before, after|
      CGI.escape(before).should == escape_for_uri(after)
    end
  end

  it "ERB::Util.u(alias of ERB::Util.url_encode)" do
    require "erb"
    gekiteki? do |before, after|
      ERB::Util.u(before).should == escape_for_uri(after.gsub('+', '%20'))
    end
  end

  it "Rack::Utils.escape" do
    require 'rack/utils'
    gekiteki? do |before, after|
      Rack::Utils.escape(before).should == escape_for_uri(after)
    end
  end

  it "URI.encode(obsolete?)" do
    require "uri"
    gekiteki? do |before, after|
      URI.encode(before).should == after.gsub('+', '%20')
    end
  end
  
  it "URI.encode_www_form_component(not obsolete)" do
    require "uri"
    gekiteki? do |before, after|
      URI.encode_www_form_component(before).should == escape_for_uri(after)
    end
  end

  it "test failed" do
    fail "failed test this is no problem..."
  end
end
