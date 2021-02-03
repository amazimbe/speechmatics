# -*- encoding: utf-8 -*-

require 'rubygems'
require 'active_support/all'

require_relative "./speechmatics/version"
require_relative './speechmatics/configuration'
require_relative './speechmatics/connection'
require_relative './speechmatics/response'
require_relative './speechmatics/response/error'
Gem.find_files('speechmatics/response/error/*.rb').each { |path| require path }
require_relative './speechmatics/api'
require_relative './speechmatics/api_factory'
require_relative './speechmatics/client'
require_relative './speechmatics/user'
require_relative './speechmatics/user/jobs'


module Speechmatics
  extend Configuration
end
