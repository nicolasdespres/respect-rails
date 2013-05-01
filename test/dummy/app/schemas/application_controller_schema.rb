class ApplicationControllerSchema < Respect::Rails::ActionSchema
  helper Respect::ApplicationMacros
  def default_url_options
    super.merge(
      {
        host: "my_application.org",
      })
  end
end
