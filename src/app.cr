require "./template_command"
require "./docker_runner"
require "./multi_stage"

class App
  include TemplateCommand
  include CachedStages
  @cache_stages : Array(Hash(String, String))

  def initialize(@image_name = "", @image_tag = "", @build_params = "", @cache_stage_target = "", @dockerfile_path = "")
    if @dockerfile_path == ""
      @dockerfile_path = "./Dockerfile"
    else
      @build_params = "#{@build_params} -f #{@dockerfile_path}"
    end

    @image_tag = Time.utc.to_unix.to_s if @image_tag == ""
    @cache_stages = cache_stages
  end

  def run
    commands.each do |command|
      puts command
    end
    # DockerRunner.new(commands).run
  end

  def multistage?
    cache_stages.size > 1
  end
end
