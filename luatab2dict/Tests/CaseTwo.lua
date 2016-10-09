table = {
	my_server = {
		server = "http://server.com",
		http_headers = { "Content-Type", "application/octet-stream; charset=utf-8" },
		accepted_mimes = { "application/octet-stream", "application/x-protobuf" },
		timeout = 5,
		params = {
			api_version = "1.0",
			app = {
				id = "0018",
				name = "ServiceOne",
				is_paid_app = false
			},
			geo = {
				latitude = 0.0,
				longitude = 0.0
			},
			device = {
				os = "IOS",
				ip = "?.?.?.?",
				os_version = "10.1",
			},
			adslots = {
				{
					id = "246759",
					adtype = "SPLASH",
					pos = "FLOW",
					accepted_creative_types =  { "IMAGE" },
					accepted_size = {
						{
							width = 1242,
							height = 2208,
						}
					}
				}
			}
		}
	},
	cust_server = {
		server = "http://updateserver.com",
		http_headers = { "Content-Type", "text/plain" },
		accepted_mimes = { "text/json" },
		timeout = 5,
		params = {
			_t = 24,
			id = "1228319746",
			os = "2",
			dev = "Apple"
		}
	}
}

--
-- XCTest call this function
--
function CaseTwo()
	return table
end