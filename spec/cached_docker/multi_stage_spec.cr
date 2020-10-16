require "../spec_helper"

class Dummy
  include CachedDocker::CachedStages
  @image_name : String

  def initialize
    @image_names = ["gcr.io/docker-rails-258302/rails-sqlite"]
    @image_name = @image_names[0]
    @dockerfile_path = "./Dockerfile"
    @cache_stage_target = ""
  end
end

describe CachedDocker::CachedStages do
  it "#commands" do
    subject = Dummy.new
    subject.cache_stages.should eq([{"name" => "gcr.io/docker-rails-258302/rails-sqlite:cache-builder", "target" => "builder"}])
  end
end
