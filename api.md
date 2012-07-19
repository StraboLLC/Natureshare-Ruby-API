#API Specification



##Request: /api/upload


###Parameters:
	* thumbnail (.png File)
	* media_file (.jpg or .mov File)
	* capture_info (.json File)
	* geo_data (.json File)
	
	
###Returns:
	* error (Boolean)
	* 	








###capture_info.json
	* created_at (double unix timestamp)
	* geodata_file (string)
	* coords [latitude(double), longitude(double)]
	* heading (double)
	* media_file (string)
	* thumbnail_file (string)
	* title (string)
	* token (string)
	* media_type (string) either "video" or "image"
	* uploaded_at (double unix timestamp)


###geoData json file
	* points [{
		* timestamp (double)
		* accuracy (double)
		* coords [lat (double), long (double)]
		* heading (double)
	}]