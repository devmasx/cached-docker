module CachedDocker::TemplateCommand
  @push = true

  def commands
    [
      "docker pull #{@image_name}",
      pull_cache_steps,
      build_cache_steps,
      "docker build #{@build_params} #{cache_froms} \
      -t #{@image_name} \
      -t #{@image_name}:#{@image_tag} \
      .",
      @push ? push_commands : [] of String,
    ].flatten
  end

  def push_commands
    [
      push_cache_steps,
      "docker push #{@image_name}:#{@image_tag}",
      "docker push #{@image_name}",
    ]
  end

  def cache_froms
    stages = @cache_stages.map { |stage| "--cache-from=#{stage["name"]}" }.join(" ")
    "#{stages} --cache-from=#{@image_name}"
  end

  def pull_cache_steps
    @cache_stages.map { |stage| "docker pull #{stage["name"]}" }
  end

  def push_cache_steps
    @cache_stages.map { |stage| "docker push #{stage["name"]}" }
  end

  def build_cache_steps
    @cache_stages.map do |stage|
      "docker build #{@build_params} #{cache_froms} --target #{stage["target"]} ."
    end
  end
end
