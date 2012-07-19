require "aws/s3"
AMAZON_ACCESS_KEY_ID="AKIAJOULK3IV4RKHDUFA"
AMAZON_SECRET_ACCESS_KEY="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"
AMAZON_BUCKET="ns.data.api.strabo.co"

PANDA_ACCESS_KEY="06905d6e882888ddf7ca"
PANDA_SECRET_KEY="88ec9270a1870adfcf33"
PANDA_CLOUD_ID="07b0993ca77b56f151355ca2079b7951"


con = AWS::S3::Base.establish_connection!(
  :access_key_id => AMAZON_ACCESS_KEY_ID,
  :secret_access_key => AMAZON_SECRET_ACCESS_KEY
)
Panda.configure do
  access_key PANDA_ACCESS_KEY
  secret_key PANDA_SECRET_KEY
  cloud_id PANDA_CLOUD_ID
end


aws_bucket = AMAZON_BUCKET