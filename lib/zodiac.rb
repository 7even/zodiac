require 'funtimes'
require 'i18n'
I18n.config.load_path += Dir.glob(File.dirname(File.expand_path(__FILE__)) + '/locales/*.yml')

require 'zodiac/finder'
require 'zodiac/date'
