NsApiStraboCo::Application.routes.draw do

  match "/upload" => "upload#upload", :as => :upload

end
