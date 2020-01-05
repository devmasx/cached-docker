require "../spec_helper"

class Dummy
  include CachedDocker::CachedStages

  def initialize
    @image_name = "gcr.io/docker-rails-258302/rails-sqlite"
    @dockerfile_path = "./Dockerfile"
    @cache_stage_target = ""
  end
end

describe CachedDocker::CachedStages do
  it "#commands" do
    subject = Dummy.new
    subject.cache_stages.should eq([{"name" => "gcr.io/docker-rails-258302/rails-sqlite:cache-build", "target" => "build"}])
  end
end
