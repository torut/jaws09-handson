require 'aws-sdk'
require 'json'

def lambda_handler(event:, context:)

  objects = Aws::S3::Resource.new(
    :region => ENV['REGION'],
    :access_key_id => ENV['ACCESS_KEY'],
    :secret_access_key => ENV['SECRET_ACCESS_KEY'],
  ).bucket(ENV['BUCKET_NAME']).objects

  response = []
  objects.each do |obj|
    response.push({
      :filename => obj.key,
      :filesize => obj.content_length,
      :mime_type => obj.object.content_type,
      :last_modified => obj.last_modified.strftime('%F %T'),
      :url => URI.parse(obj.presigned_url(:get, expires_in: 90)),
    })
  end

  {
    statusCode: 200,
    body: response,
  }

end

