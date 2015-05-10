module AbilitySerializer

  Ability.all_actions.each do |action|
    define_method("can_#{action}") do
      ability.can? action, self
    end
  end

  def serializable_hash(options={})
    self.ability = options[:ability]

    options.reverse_merge!(
      only: json_only_options,
      methods: json_ability_methods,
      include: json_include_options
    )

    super(options)
  end


  private
  attr_accessor :ability

  def json_only_options
    []
  end

  def json_include_options
    []
  end

  def json_ability_methods
    return [] unless ability
    Ability.all_actions.map{|action| "can_#{action}"}
  end
end