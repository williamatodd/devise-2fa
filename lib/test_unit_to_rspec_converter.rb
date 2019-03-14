class TestUnitToRspecConverter

  attr_accessor :test_case, :filename

  def initialize(filename)
    self.filename = filename
    #not all statements should have open/close recognition
    #using plain ' ' helps keeping the input simple
    #assert true <-> assert('4'+6.to_s+('a'))
    @open = '[\( ]'       #opening/beginning of statment
    @close = '[\)]{0,1}'  #closing/end of statment
    @end = '\s*$'  #end of line

    #watch out, they both add a () -> $1 -> $2
    @b_open = '(\{|do)'   #opening of block TODO without params ?
    @b_close = '(\}|end)' #closing of block TODO without params ?

    #misc
    @controller = '[A-Za-z0-9]*'
    @simple_ex = '[^\(].*' #a simple expression, too complicated 'assert_equal a(b,c(1))' can not be transformed
  end

  def convert
    self.read
      [
      :remove_comments_from_asserts,
      :convert_method_name,
      :convert_assert_false,
      :convert_assert_true,
      :convert_assert_equal,
      :convert_test_helper,
      :convert_test_unit_class_declaration,
      :convert_setup_method,
      :convert_simple_assertions,
      :convert_controller_assertions,
      :convert_raising_assertions,
      ].each { |m| self.send m }
    self.write
  end

  def read
    self.test_case = File.read(self.filename)
  end

  def write
    FileUtils.mkdir_p(File.dirname(spec_name))
    File.open self.spec_name, "w+" do |file|
      file.flush
      file << self.test_case
    end
  end

  def spec_name
    tmp = self.filename.clone
    tmp.gsub!(/test\/functional/,"spec/controllers")
    tmp.gsub!(/test\/unit/,"spec/models")
    tmp.gsub!(/test\/helper/,"spec/helpers")
    tmp.gsub!(/_test\.rb/,"_spec.rb")
  end

  # def setup => before(:each) do
  def convert_setup_method
    test_case.gsub!(/def setup/,"before(:each) do")

  end

  # class VideoTest < Test::Unit::TestCase
  # => describe Video do
  def convert_test_unit_class_declaration
    test_case.gsub!(/class (#{@controller})Test\s*\<.\s*(Test::Unit::TestCase|ActionController::TestCase)#{@end}/) { |s| "describe #{$1} do\n  integrate_views" }

    #remove now uneccessary methods
    test_case.gsub!(/\s*@response\s*=\s*ActionController::TestResponse.new#{@end}/,"")
    test_case.gsub!(/\s*@controller\s*=\s*#{@controller}Controller.new#{@end}/,"")
    test_case.gsub!(/\s*@request\s*=\s*ActionController::TestRequest.new#{@end}/,"")
    test_case.gsub!(/\s*require '.*?_controller'#{@end}/,"")


    #remove reraising
    test_case.gsub!(/\s*#\s*Re-raise errors caught by the controller.#{@end}/,"")
    test_case.gsub!(/class #{@controller}Controller; def rescue_action\(e\) raise e end; end#{@end}/,"")
  end

  # require File.dirname(__FILE__) + '/../test_helper'
  # => require File.dirname(__FILE__) + '/../spec_helper'
  def convert_test_helper
    test_case.gsub!(/test_helper/,'spec_helper')
  end

  # def test_foo -> it "test_foo" do
  def convert_method_name
    test_case.gsub!(/def test_([a-z_]*)#{@end}/) { |s| "it '#{$1.gsub('_',' ')}' do" }
  end


  # ASSERT foo, "something should something"
  # ->
  #  #something should something
  #  assert foo
  def remove_comments_from_asserts
    test_case.gsub!(/^(\s*)(assert !?.*), ["'](.*)["']#{@end}/) { |s| "#{$1}##{$3}#{$1}#{$2}" }
  end

  # ASSERT foo -> foo.should
  def convert_assert_true
    test_case.gsub!(/assert#{@open}(.*)#{@close}#{@end}/) { |s| params($1) +".should_not be_false" }
  end

  # ASSERT !foo -> foo.should_not be_true
  def convert_assert_false
    test_case.gsub!(/assert#{@open}!(.*)#{@close}#{@end}/) { |s| "#{$1}.should_not be_true" }
  end

  # ASSERT_EQUAL(s) foo, bar -> bar.should == foo
  def convert_assert_equal
    test_case.gsub!(/assert_equal[s]*#{@open}(#{@simple_ex}?),\s*(.*)#{@close}#{@end}/) { |s| params($2)+".should == #{$1}" }
  end

  def convert_simple_assertions
    # ASSERT_MATCH (/X/,Y)
    test_case.gsub!(/assert_match#{@open}([^,\)]*),([^,\)]*)#{@close}#{@end}/) { |s| params($2)+".should =~ #{$1}" }

    # ASSERT_NIL X -> x.should be_nil
    test_case.gsub!(/assert_nil#{@open}(#{@simple_ex})#{@close}#{@end}/) { |s| params($1)+".should be_nil" }
    test_case.gsub!(/assert_not_nil#{@open}(#{@simple_ex})#{@close}#{@end}/) { |s| params($1)+".should_not be_nil" }
  end

  def convert_controller_assertions
    #ASSERT_RESPONSE :success -> respone.should be_success
    test_case.gsub!(/assert_response :(.*)#{@end}/) { |s| "response.should be_#{$1}" }
    #return code 200/302/500...
    test_case.gsub!(/assert_response (\d{3})#{@end}/) { |s| "response.headers['Status'][0..3].to_i.should == #{$1}" }

    #ASSERT_REDIRECTED_TO X -> response.should redirect_to(X)
    test_case.gsub!(/assert_redirected_to (.*)#{@end}/) { |s| "response.should redirect_to(#{$1})" }

    #ASSERT_TEMPLATE X -> response.should render_template(X)
    test_case.gsub!(/assert_template (.*)#{@end}/) { |s| "response.should render_template(#{$1})" }
  end

  def convert_raising_assertions
    #ASSERT_NOTHING_RAISED {X} ->  lambda {...}.should_not raise_error
    test_case.gsub!(/assert_nothing_raised \{(.*?)\}/m) { |s| "lambda {#{$1}}.should_not raise_error" }

    #ASSERT_RAISE(Y(without comma)) {X} ->  lambda {...}.should raise_error(Y)
    test_case.gsub!(/assert_raise[s]*#{@open}([^,]*?)#{@close} (\{|do)(.*?)(\}|end)/m) { |s| "lambda {#{$3}}.should raise_error(#{$1})" }
  end


  #HELPERS
  def params term
    (term =~ /[-*+\/\% ]|:\d|: |=/) ? "(#{term})" : term
  end
end
