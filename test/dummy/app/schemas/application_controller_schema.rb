class ApplicationControllerSchema < Respect::Rails::OldActionSchema
  def default_url_options
    super.merge(
      {
        host: "my_application.org",
      })
  end
end
