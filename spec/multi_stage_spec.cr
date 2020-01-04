require "./spec_helper"

class Dummy
  include CachedStages

  def initialize
    @image_name = "gcr.io/docker-rails-258302/rails-sqlite"
    @docker_file_path = "./spec/fixtures/Dockerfile.dev"
    @cache_stage_target = ""
  end
end

subject = Dummy.new

puts subject.cache_stages
