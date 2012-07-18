module ErdHandler
  #$ERD_LOGGER = Logger.new(STDERR)
  $ERD_LOGGER = Logger.new('erd.log')
  #$ERD_LOGGER.level = Logger::WARN
  $ERD_LOGGER.level = Logger::DEBUG
end
