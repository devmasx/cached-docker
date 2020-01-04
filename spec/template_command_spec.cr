require "./spec_helper"

class Service
  include TemplateCommand

  def initialize
    @image_name = "gcr.io/docker-rails-258302/rails-sqlite"
    @docker_file_path = "./spec/fixtures/Dockerfile.dev"
    @cache_stage_target = ""
    @image_tag = "v1"
    @build_params = ""
    @cache_stages = [] of String
    @cache_stages = [
      {"name" => "gcr.io/docker-rails-258302/rails-sqlite:cache-build", "target" => "build"},
      # {"name" => "gcr.io/docker-rails-258302/rails-sqlite:cache-test", "target" => "test"},
    ]
  end
end

service = Service.new

puts service.commands
