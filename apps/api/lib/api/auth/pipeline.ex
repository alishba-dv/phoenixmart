defmodule Api.Auth.Pipeline do

  use Guardian.Plug.Pipeline,otp_app: :api,
  module:  Api.Auth.Guardian,
  error_handler: Api.AuthErrorHandler


plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
plug Guardian.Plug.EnsureAuthenticated
plug Guardian.Plug.LoadResource



end
