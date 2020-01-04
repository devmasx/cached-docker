require "./template_command"
require "./docker_runner"
require "./multi_stage"

class App
  include TemplateCommand
  include CachedStages
  @cache_stages : Array(Hash(String, String))

  def initialize(@image_name = "", @image_tag = "", @build_params = "", @cache_stage_target = "")
    @docker_file_path = "./Dockerfile"
    # @image_tag = "12345678912312" if @image_tag == ""
    @cache_stages = cache_stages
  end

  def run
    # commands.each do |c|
    #   puts c
    # end
    DockerRunner.new(commands).run
  end

  def multistage?
    cache_stages.size > 1
  end
end
