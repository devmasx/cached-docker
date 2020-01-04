require "./spec_helper"

describe App do
  it "#commands" do
    subject = App.new(
      "gcr.io/docker-rails-258302/rails-sqlite",
      "v1",
      ""
    )
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

  it "#commands" do
    subject = App.new(
      "gcr.io/docker-rails-258302/rails-sqlite",
      "v1",
      "--dockerfile ./Dockerfile.dev"
    )
    subject.commands.should eq([
      "docker pull gcr.io/docker-rails-258302/rails-sqlite",
      "docker pull gcr.io/docker-rails-258302/rails-sqlite:cache-build",
      "docker build --dockerfile ./Dockerfile.dev --cache-from=gcr.io/docker-rails-258302/rails-sqlite:cache-build --cache-from=gcr.io/docker-rails-258302/rails-sqlite --target build .",
      "docker build --dockerfile ./Dockerfile.dev --cache-from=gcr.io/docker-rails-258302/rails-sqlite:cache-build --cache-from=gcr.io/docker-rails-258302/rails-sqlite -t gcr.io/docker-rails-258302/rails-sqlite -t gcr.io/docker-rails-258302/rails-sqlite:v1 .",
      "docker push gcr.io/docker-rails-258302/rails-sqlite:cache-build",
      "docker push gcr.io/docker-rails-258302/rails-sqlite:v1",
      "docker push gcr.io/docker-rails-258302/rails-sqlite",
    ])
  end
end
