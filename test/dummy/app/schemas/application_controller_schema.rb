class ApplicationControllerSchema < Respect::Rails::ActionSchema
  def default_url_options
    super.merge(
      {
        host: "my_application.org",
      })
  end
end
