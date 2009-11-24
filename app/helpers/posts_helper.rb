# Helper methods defined here can be accessed in any controller or view in the application

Blog.helpers do
  def simple_format(text)
    text.gsub(/\n/m, "<br />\n")
  end
end