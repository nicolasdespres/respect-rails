Respect::Rails.setup do |config|
  config.app_documentation <<-EOS
    The greatest address book out there.

    This application let you store your contacts information on a server database.
  EOS

  config.helpers Respect::ApplicationMacros
end
