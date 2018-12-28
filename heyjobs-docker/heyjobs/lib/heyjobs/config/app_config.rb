require 'erb'
class AppConfig
  def self.load
    Dir['lib/heyjobs/config/*.yml'].each do |filename|
      config = YAML::load(ERB.new(File.read(filename)).result)
      config.keys.each do |key|
        cattr_accessor key
        send("#{key}=", config[key])
      end
    end
  end
end
