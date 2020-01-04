module CachedStages
  def cache_stages : Array(Hash(String, String))
    if @cache_stage_target && !@cache_stage_target.empty?
      [{
        "name"   => "#{@image_name}:cache-#{@cache_stage_target}",
        "target" => @cache_stage_target,
      }]
    else
      stages = try_find_stages.map do |stage|
        {"name" => "#{@image_name}:cache-#{stage}", "target" => stage}
      end
    end
  end

  def try_find_stages
    file_lines = File.read_lines(@dockerfile_path).select { |line| /FROM/ =~ line }
    file_lines.reduce([] of String) do |memo, line|
      if match = /(?<=(as|AS) ).*$/.match(line)
        memo << match[0].strip
      end
      memo
    end
  end
end
