require 'bundler/setup'

require 'rexml/document'

require 'graph.njae'
include GraphNjae

require 'porter2stemmer'
require 'logger'

require_relative 'erd_handler/exceptions'
require_relative 'erd_handler/logger'
require_relative 'erd_handler/label'
require_relative 'erd_handler/erd'
require_relative 'erd_handler/box'
require_relative 'erd_handler/link'
require_relative 'erd_handler/abstract_erd'

