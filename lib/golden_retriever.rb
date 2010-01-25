module GoldenRetriever

  def self.included(controller)
    controller.before_filter :load_resource
  end

private
  def load_resource
    resource_keys = ActionController::Routing::Routes.routes_by_controller[controller_name][action_name][params.keys][0][0].segment_keys.map(&:to_s).grep(/id$/)

    parent = nil
    resource_keys.each do |key|
      singular_name = key.match(/^(.*)_id$/).try(:[], 1) || controller_name.singularize
      object = if parent
        parent.send(singular_name.pluralize)
      else
        singular_name.camelize.constantize
      end.find params[key]
      instance_variable_set("@#{singular_name}", object)
      parent = object
    end

    if resource_keys.last != 'id'
      singular_name = controller_name.singularize
      objects = if parent
        parent.send(singular_name.pluralize)
      else
        singular_name.camelize.constantize.all
      end
      instance_variable_set("@#{controller_name}", objects)
    end

    if %w(new create).include? action_name
      singular_name = controller_name.singularize
      objects = if parent
        parent.send(singular_name.pluralize).build
      else
        singular_name.camelize.constantize.new
      end
      instance_variable_set("@#{singular_name}", objects)
    end

  end

end
