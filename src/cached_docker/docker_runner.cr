class CachedDocker::DockerRunner
  def initialize(@commands : Array(String))
  end

  def run
    pull_commands.each do |command|
      system(command)
    end
    # Sync execute, stop if fail
    system((build_commands + push_commands).join(" && "))
  end

  def pull_commands
    @commands.select { |c| /docker pull/ =~ c }
  end

  def build_commands
    @commands.select { |c| /docker build/ =~ c }
  end

  def push_commands
    @commands.select { |c| /docker push/ =~ c }
  end
end
