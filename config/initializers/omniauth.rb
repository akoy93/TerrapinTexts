OmniAuth.config.logger = Rails.logger

FACEBOOK_APP_ID = "328570107258596"
FACEBOOK_SECRET = "0902263418789178986487421ad0cc3b"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_SECRET
end
