require "../spec_helper"

describe CachedDocker::App do
  it "#commands" do
    subject = CachedDocker::App.new(
      "crystal-dev",
      "v1",
      "",
    )
    subject.commands.should eq([
      "docker pull crystal-dev",
      "docker pull crystal-dev:cache-builder",
      "docker build  --cache-from=crystal-dev:cache-builder --cache-from=crystal-dev --target builder .",
      "docker build  --cache-from=crystal-dev:cache-builder --cache-from=crystal-dev -t crystal-dev -t crystal-dev:v1 .",
      "docker push crystal-dev:cache-builder",
      "docker push crystal-dev:v1",
      "docker push crystal-dev",
    ])
  end

  it "#initialize set default values" do
    subject = CachedDocker::App.new(
      "crystal-dev",
      "",
      "--build-arg=NPM_TOKEN=1234",
      "",
      "Dockerfile"
    )
    subject.image_tag.should eq(Time.utc.to_unix.to_s)
    subject.dockerfile_path.should eq("Dockerfile")
    subject.build_params.should eq("--build-arg=NPM_TOKEN=1234 -f Dockerfile")
  end

  it "#commands" do
    subject = CachedDocker::App.new(
      "crystal-dev",
      "v1",
      "--build-arg=NPM_TOKEN=1234",
      "",
      "Dockerfile"
    )

    subject.commands.should eq([
      "docker pull crystal-dev",
      "docker pull crystal-dev:cache-builder",
      "docker build --build-arg=NPM_TOKEN=1234 -f Dockerfile --cache-from=crystal-dev:cache-builder --cache-from=crystal-dev --target builder .",
      "docker build --build-arg=NPM_TOKEN=1234 -f Dockerfile --cache-from=crystal-dev:cache-builder --cache-from=crystal-dev -t crystal-dev -t crystal-dev:v1 .",
      "docker push crystal-dev:cache-builder",
      "docker push crystal-dev:v1",
      "docker push crystal-dev",
    ])
  end
end
