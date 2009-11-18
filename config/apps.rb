# This file mount each application to a specific path.
Padrino.mount("root", :app_class => "Website", :app_file => Padrino.root('app.rb')).to("/")