require "./spec_helper"

class Dummy
  include CachedStages

  def initialize
    @image_name = "gcr.io/docker-rails-258302/rails-sqlite"
    @docker_file_path = "./Dockerfile"
    @cache_stage_target = ""
  end
end

describe CachedStages do
  it "#commands" do
    subject = Dummy.new
    subject.cache_stages.should eq([{"name" => "gcr.io/docker-rails-258302/rails-sqlite:cache-build", "target" => "build"}])
  end
end
