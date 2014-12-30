class RcxSkytap::HerSkytapAuthentication < Faraday::Middleware
  def call(env)
  	header = "Basic #{Base64.encode64( [RequestStore.store[:skytap_username], RequestStore.store[:skytap_api_token] ].join(':')).gsub("\n", '')}"
		env[:request_headers]["Authorization"] = header
    @app.call(env)
  end
 end