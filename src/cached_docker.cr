require "./cached_docker/app"
require "commander"

cli = Commander::Command.new do |cmd|
  cmd.use = "Cached Docker"

  cmd.flags.add do |flag|
    flag.name = "image_name"
    flag.short = "-i"
    flag.long = "--image-name"
    flag.default = ""
    flag.description = "Image name without tag"
  end

  cmd.flags.add do |flag|
    flag.name = "image_tag"
    flag.short = "-t"
    flag.long = "--image-tag"
    flag.default = ""
    flag.description = "Image tag (Default Time in unix seconds)"
  end

  cmd.flags.add do |flag|
    flag.name = "build_params"
    flag.long = "--build-params"
    flag.default = ""
    flag.description = "Add any docker build flag, --build-params=\"--build-arg=TOKEN=$TOKEN\""
  end

  cmd.flags.add do |flag|
    flag.name = "cache_stage_target"
    flag.long = "--cache-stage-target"
    flag.default = ""
    flag.description = "Name of the stage target for use in cache, two images will be compiled, the stage target and the last stage"
  end

  cmd.flags.add do |flag|
    flag.name = "dockerfile_path"
    flag.long = "--file"
    flag.short = "-f"
    flag.default = ""
    flag.description = "Name of the Dockerfile (Default is 'PATH/Dockerfile')"
  end

  cmd.run do |options, arguments|
    if options.string["image_name"] == ""
      raise "--image-name is required"
    end

    CachedDocker::App.new(
      options.string["image_name"],
      options.string["image_tag"],
      options.string["build_params"],
      options.string["cache_stage_target"],
      options.string["dockerfile_path"],
    ).run
  end
end
Commander.run(cli, ARGV)
