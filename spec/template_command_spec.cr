require "./spec_helper"

class Service
  include TemplateCommand

  def initialize
    @image_name = "gcr.io/docker-rails-258302/rails-sqlite"
    @dockerfile_path = "./spec/fixtures/Dockerfile.dev"
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

describe TemplateCommand do
  it "#commands" do
    subject = Service.new
    subject.commands.should eq([
      "docker pull gcr.io/docker-rails-258302/rails-sqlite",
      "docker pull gcr.io/docker-rails-258302/rails-sqlite:cache-build",
      "docker build  --cache-from=gcr.io/docker-rails-258302/rails-sqlite:cache-build --cache-from=gcr.io/docker-rails-258302/rails-sqlite --target build .",
      "docker build  --cache-from=gcr.io/docker-rails-258302/rails-sqlite:cache-build --cache-from=gcr.io/docker-rails-258302/rails-sqlite -t gcr.io/docker-rails-258302/rails-sqlite -t gcr.io/docker-rails-258302/rails-sqlite:v1 .",
      "docker push gcr.io/docker-rails-258302/rails-sqlite:cache-build",
      "docker push gcr.io/docker-rails-258302/rails-sqlite:v1",
      "docker push gcr.io/docker-rails-258302/rails-sqlite",
    ])
  end
end
