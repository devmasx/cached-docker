require "./cached_docker/app"
require "./cached_docker/version"
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
    flag.description = "Name of the stage target for use in cache"
  end

  cmd.flags.add do |flag|
    flag.name = "push"
    flag.long = "--push"
    flag.short = "-p"
    flag.default = false
    flag.description = "push image"
  end

  cmd.flags.add do |flag|
    flag.name = "dockerfile_path"
    flag.long = "--file"
    flag.short = "-f"
    flag.default = ""
    flag.description = "Name of the Dockerfile (Default is 'PATH/Dockerfile')"
  end

  cmd.flags.add do |flag|
    flag.name = "version"
    flag.long = "--version"
    flag.short = "-v"
    flag.default = false
    flag.description = "Version"
  end

  cmd.flags.add do |flag|
    flag.name = "print"
    flag.long = "--print"
    flag.default = false
    flag.description = "Only print docker commands"
  end

  cmd.run do |options, arguments|
    if options.bool["version"]
      puts CachedDocker::VERSION
    elsif options.string["image_name"] == ""
      puts "--image-name is required"
      puts cmd.help
    else
      app = CachedDocker::App.new(
        {
          image_name:         options.string["image_name"],
          image_tag:          options.string["image_tag"],
          push:               options.bool["push"],
          dockerfile_path:    options.string["dockerfile_path"],
          build_params:       options.string["build_params"],
          cache_stage_target: options.string["cache_stage_target"],
        }
      )

      if options.bool["print"]
        app.commands.each { |command| puts command }
      else
        app.run
      end
    end
  end
end
Commander.run(cli, ARGV)
