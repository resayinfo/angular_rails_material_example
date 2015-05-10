class Api::V1::ApiController < ApplicationController
  respond_to :json, :html

  private

  # Renders the application.html.haml on all html requests.
  # Attempts to serialize json responses
  def render(*args)
    respond_to do |format|
      format.html{ super 'layouts/application' }
      format.json{ super *filter_json_args(args) }
    end
  end

  def pagination_info(obj)
    return {} unless obj.respond_to?(:total_pages)
    {
      meta: {
        pagination: {
          total_pages: obj.total_pages,
          page: current_page
    }}}
  end

  def current_page
    (params[:page] || 1).to_i
  end

  def filter_json_args(args)
    hash_arg_index = get_hash_index args # index of passed in hash
    json_obj       = if !!hash_arg_index
      args[hash_arg_index][:json]
    else
      instantiated_resource_hash
    end

    json_hash = {json: json_obj.to_json(json_options)}

    if !!hash_arg_index
      # hash options passed in
      # merge new hash
      args[hash_arg_index].merge! json_hash
    else
      # add hash to args
      args[args.count] = json_hash
    end

    args
  end

  def instantiated_resource_hash
    # check for plural instance variable
    resource_name = controller_name
    unless resource = instance_variable_get('@' + resource_name)
      # check for singular instance variable
      resource_name = resource_name.singularize
      resource      = instance_variable_get '@'+ resource_name
    end

    if !!resource
      {resource_name => resource}.merge pagination_info(resource)
    else
      {}
    end
  end

  def get_hash_index(arr)
    arr.each_with_index do |a, i|
      if a.is_a? Hash
        return i
      end
    end
    return nil
  end

  def json_options
    {ability: current_ability}
  end
end