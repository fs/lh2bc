$:.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))

require 'optparse'
require 'lh2bc'

options = {
  'verbose' => false,
  'basecamp' => {},
  'lighthouse' => {}
}

OptionParser.new do |opts|
  opts.banner = 'Usage: lh2bc [options]'
  [
    [['--bc-project-id project', 'Basecamp project id'], 'basecamp/project_id'],
    [['--bc-domain domain', 'Basecamp domain'], 'basecamp/domain'],
    [['--bc-username username', 'Basecamp username'], 'basecamp/username'],
    [['--bc-password password', 'Basecamp password'], 'basecamp/password'],
    [['--lh-account account', 'Lighthouse account'], 'lighthouse/account'],
    [['--lh-token token', 'Lighthouse token'], 'lighthouse/token'],
    [['-c', '--config config.yml', 'With configuration file'], 'config'],
    [['-v', '--[no-]verbose', 'Run verbosely'], 'verbose'],
  ].each do |option|
    opts.on(*option[0]) do |value|
      options.path[option[1]] = value
    end
  end

  opts.on_tail('--version', 'Show version') do
    puts "lh2bc version: #{Lh2Bc::VERSION::STRING}"
    exit
  end
end.parse!

if options['config']
  unless File.readable?(options['config'])
    puts "Configuration file #{options['config']} unreadable"
    exit
  end

  options = options.deep_merge(YAML.load(File.read(options['config'])))
end

Lh2Bc::Base.logger.level = options['verbose'] ? Logger::DEBUG : Logger::INFO
Lh2Bc::Base.new(options).sync
