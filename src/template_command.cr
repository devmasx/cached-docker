module TemplateCommand
  def commands
    [
      "docker pull #{@image_name}",
      pull_cache_steps,
      "docker build #{@build_params} #{cache_froms} \
        -t #{@image_name} \
        -t #{@image_name}:#{@image_tag} \
       .",
      build_cache_steps,
      push_cache_steps,
      "docker push #{@image_name}:#{@image_tag}",
      "docker push #{@image_name}",
    ].flatten
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

# execute_command("docker pull #{IMAGE_NAME}")

# system("docker pull #{CACHE_IMAGE_NAME}")
# puts "continue"

# commands =
#   "docker build #{BUILDPARAMS} --target #{CACHE_STAGE_TARGET} --cache-from=#{CACHE_IMAGE_NAME} -t #{CACHE_IMAGE_NAME} ." \
#   " && " \
#   "docker build #{BUILDPARAMS} --cache-from=#{CACHE_IMAGE_NAME} -t #{IMAGE_NAME} -t #{IMAGE_NAME}:#{IMAGE_TAG} ." \
#   " && " \
#   "docker push #{IMAGE_NAME}:#{IMAGE_TAG}"

# # puts commands
# system(commands)
