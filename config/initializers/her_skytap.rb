Her::API.setup url: "https://cloud.skytap.com", send_only_modified_attributes: true do |c|
	c.use SkytapAuthentication
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::AcceptJSON
  c.use Her::Middleware::DefaultParseJSON
  c.use Faraday::Adapter::NetHttp
end