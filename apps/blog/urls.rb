Blog.urls do
  map :blog do |blog|
    blog.map :demo do |demo|
      demo.map(:index).to("")
    end
  end
end