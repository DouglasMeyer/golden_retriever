require 'teststrap'

class FakeParent
  def self.find(id)
    new if id == :fake_parent_id
  end
  def fake_posts
    fake_post = 'fake_posts'
    class << fake_post
      def build
        :build_fake_posts
      end
    end
    fake_post
  end
end

context "Nested Restful Controller" do
  setup do
    class FakePostsController
      def self.action_name=(name)
        @@params = HashWithIndifferentAccess.new
        @@params[:fake_parent_id] = :fake_parent_id
        @@params[:id] = :fake_post_id if name == 'show'
        ActionController::Routing::Routes.action_and_params(name, @@params)
        @@action_name = name
      end
      def self.resource_find_method(resource); :find; end
    end
    FakePostsController
  end

  should "set @fake_parent to FakeParent.find params[:fake_parent_id]" do
    topic.action_name = 'index'
    topic.new.tap{|c|
      c.send :load_resource
    }.instance_variable_get('@fake_parent').kind_of? FakeParent
  end

  context "for a collection request" do
    setup do
      topic.action_name = 'index'
      topic.new.tap{|c| c.send :load_resource }
    end

    should "set @fake_posts to be @fake_parent.fake_posts" do
      topic.instance_variable_get('@fake_posts')
    end.equals('fake_posts')
  end

  context "for a request to :new" do
    setup do
      topic.action_name = 'new'
      topic.new.tap{|c| c.send :load_resource }
    end

    should "set @fake_post to be @fake_parent.fake_posts.build" do
      topic.instance_variable_get('@fake_post')
    end.equals(:build_fake_posts)
  end

end
