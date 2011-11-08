require 'spec_helper'

describe RuntimeHelper do
  describe "class InnerRuntime" do
    it "should get inner runtime with params as func" do
      rt = InnerRuntime.new
      rt.add_params :a => 1, :b => "2"
      rt.a.should == 1
      rt.b.should == "2"
      lambda do
        rt.c
      end.should raise_error
      rt.add_params :c => "3"
      rt.a.should == 1
      rt.b.should == "2"
      rt.c.should == "3"
    end

    it "should have xml method to get DOM" do
      rt = InnerRuntime.new nil
      doc = rt.xml('<abc>a</abc>')
      (doc/'abc').inner_text.should == "a"
    end

    it "should parse xml" do
      content = <<EOF
      <feed>
        <item>
          <title>item1</title>
        </item>
        <item>
          <title>item2</title>
        </item>
        <item>
          <title>item3</title>
        </item>
      </fedd>
EOF
      rt = InnerRuntime.new nil
      ret = rt.parse_xml content, "feed > item" do |i|
        { :title => (i / 'title').inner_text }
      end
      ret.should == [{:title => "item1"}, {:title => "item2"}, {:title => "item3"}]
    end
  end
end