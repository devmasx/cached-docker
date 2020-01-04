require "./docker_runner.cr"

class CachedMultistage
  include CachedStages
  include Templates::CommandsMultiStage

  def initialize(@image_name = "", @image_tag = "", @cache_stages : Array = [] of Hash(String, String), @build_params = "")
    @cache_stages = cache_stages
  end

  def pull_build_push
    DockerRunner.new(commands).run
  end
end
