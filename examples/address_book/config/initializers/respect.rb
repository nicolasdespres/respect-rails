Respect::Rails.setup do |config|
  # The title and description of your application.
  config.app_documentation <<-EOS.strip_heredoc
    The greatest address book out there.

    This application let you store your contacts information on a server database.
  EOS

  # Specify as many helpers as you want here. Helpers extend the schema definition DSL so
  # that you can factor your code.
  config.helpers Respect::ApplicationMacros

  # Set the application name use in the documentation. By default it is the same
  # as your application class.
  # config.doc_app_name = "My custom app name"
end
