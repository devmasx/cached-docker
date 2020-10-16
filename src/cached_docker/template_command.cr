module CachedDocker::TemplateCommand
  def commands
    [
      "docker pull #{@image_name}",
      pull_cache_steps,
      build_cache_steps,
      "docker build #{@build_params} #{cache_froms} #{image_tags} .",
      push_cache_steps,
      "docker push #{@image_name}:#{@image_tag}",
      "docker push #{@image_name}",
    ].flatten
  end

  def image_tags
    @image_names.map do |image_name|
      "-t #{image_name} -t #{image_name}:#{@image_tag}"
    end.join(" ")
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
