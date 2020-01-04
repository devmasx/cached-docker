require "./app"
require "cli"

class CliApp < Cli::Command
  class Help
    header "Cached Docker"
  end

  class Options
    string "--image-name"
    string "--image-tag", default: ""
    string "--cache-stage-target", default: ""
    string "--build-params", default: ""
  end

  def run
    App.new(
      args.image_name,
      args.image_tag,
      ""
    ).run
  end
end

CliApp.run(ARGV)
