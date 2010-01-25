require 'teststrap'

context "Restful Controller" do
  setup do
    class FakePostsController
      def self.action_name=(name)
        @@params = HashWithIndifferentAccess.new
        @@params[:id] = :fake_post_id if name == 'show'
        ActionController::Routing::Routes.action_and_params(name, @@params)
        @@action_name = name
      end
    end
    FakePostsController
  end

  should "add before_filter :load_resource" do
    topic.before_filter
  end.equals(:load_resource)

  context "for a collection request" do
    setup do
      topic.action_name = 'index'
      topic.new.tap{|c|
        c.send :load_resource
      }.instance_variable_get('@fake_posts')
    end
    should "set @fake_posts to FakePost.all" do
      topic
    end.equals(:all)
  end

  context "for a member request" do
    setup do
      topic.action_name = 'show'
      topic.new.tap{|c| c.send :load_resource }
    end
    should "set @fake_post to FakePost.find params[:id]" do
      FakePost.find_id == :fake_post_id and
      topic.instance_variable_get('@fake_post')
    end.equals(:find)
  end

  context "for a :new request" do
    setup do
      topic.action_name = 'new'
      topic.new.tap{|c| c.send :load_resource }
    end
    should "set @fake_post to FakePost.new" do
      topic.instance_variable_get('@fake_post')
    end.equals(:new)
  end

end
