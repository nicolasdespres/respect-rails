class ApplicationSchema < Respect::Rails::Base
  def default_url_options
    super.merge(
      {
        host: "my_application.org",
      })
  end
end
