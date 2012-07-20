NsApiStraboCo::Application.routes.draw do

  match "/upload" => "upload#upload", :as => :upload

  match "/" => redirect("http://api.strabo.co"), :as => :root

end
