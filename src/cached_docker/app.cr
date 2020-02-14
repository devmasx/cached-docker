require "./template_command"
require "./docker_runner"
require "./multi_stage"

class CachedDocker::App
  include TemplateCommand
  include CachedStages
  @cache_stages : Array(Hash(String, String))
  @push = true
  getter :image_tag, :dockerfile_path, :build_params

  def initialize(*,
                 @image_name = "", @image_tag = "",
                 @push = true, @build_params = "",
                 @cache_stage_target = "", @dockerfile_path = "./Dockerfile")
    if @dockerfile_path != "./Dockerfile"
      @build_params = "#{@build_params} -f #{@dockerfile_path}"
    end

    @image_tag = Time.utc.to_unix.to_s if @image_tag == ""
    @cache_stages = cache_stages
  end

  def run
    commands.each do |command|
      puts command
    end
    DockerRunner.new(commands, @push).run
  end

  def multistage?
    cache_stages.size > 1
  end
end
