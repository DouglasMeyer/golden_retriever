require 'rubygems'
require 'riot'
require 'ostruct'

require 'active_support'

require 'golden_retriever'

# -=-=- "fixtures"/helpers
module ActionController
  module Routing
    class Routes
      def self.action_and_params(name, params)
        @@routes_by_controller ||= { 'fake_posts' => {}}
        @@routes_by_controller['fake_posts'][name] = {
          params.keys => [[ OpenStruct.new(:segment_keys => params.keys) ]]
        }
      end
      def self.routes_by_controller
        @@routes_by_controller
      end
    end
  end
end

class FakePost
  class << self
    def find_id
      @@id
    end
  end
  def self.all; :all; end
  def self.find(id)
    @@id = id
    :find
  end
  def self.new; :new; end
end

class FakePostsController
  def self.before_filter(name=nil)
    @@before_filter = name if name
    @@before_filter
  end
  def controller_name; 'fake_posts'; end
  def self.action_name; @@action_name; end
  def action_name
    self.class.action_name
  end
  def params; @@params; end
  include GoldenRetriever
end

