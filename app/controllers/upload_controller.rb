

#curl -F 'capture_info=@capture-info.json;type=application/json' -F 'geo_data=@3f96474a8a03ebc48f402b43d150a9fa.json;type=application/json' -F 'media_file=@3f96474a8a03ebc48f402b43d150a9fa.mov;type=video/quicktime' -F 'thumbnail=@3f96474a8a03ebc48f402b43d150a9fa.png;type=image/png' ns-api.heroku.com/upload

class UploadController < ApplicationController
    def upload
        puts params.to_s
        if params[:capture_info] && params[:media_file] && params[:geo_data] && params[:thumbnail]
            @r = {}
            aws_bucket = AMAZON_BUCKET
            capture_info = params[:capture_info]
            media_file = params[:media_file]
            geo_data = params[:geo_data]
            thumbnail = params[:thumbnail]
            json = JSON(capture_info.read)
            geo_json = JSON(geo_data.read)
            json['points']=geo_json['points']
            token = json["token"]
            output = json.to_json.to_s
            output = "var response = JSON.parse('#{output}'));"
            output += "S.rambles['#{token}']._processResponse(response);"
            finished=true
            if media_file.content_type == "image/jpeg"
                capture_type = "photo"
                media_file_name = ".jpg"
            elsif media_file.content_type == "video/quicktime"
                capture_type = "video"
                finished=false
                media_file_name = ".mov"
            end

            # Fill In Capture Information to Database
            @capture = Capture.where(:token => json["token"]).first
            @capture = Capture.new if !@capture
            @capture.title = json["title"]
            @capture.token = json["token"]
            @capture.latitude = json["coords"][0]
            @capture.longitude = json["coords"][1]
            @capture.heading = json["heading"]
            @capture.taken_at = Time.at(json['created_at'].to_i).to_datetime
            @capture.media_type = json["media_type"]
            @capture.orientation = json["orientation"]
            @capture.encoding_finished = false;
            @capture.mp4_finished = false;
            @capture.webm_finished = false;
            capture_path = @capture.token+"/"+@capture.token
            # Save Capture and Move Files to S3
            if  @capture.save
                AWS::S3::S3Object.store( capture_path+".json", json.to_json, aws_bucket, :content_type => 'text/json', :access => :public_read )
                AWS::S3::S3Object.store( capture_path+".js", output, aws_bucket, :content_type => 'application/javascript', :access => :public_read )
                AWS::S3::S3Object.store( capture_path+media_file_name, media_file.read, aws_bucket, :content_type => media_file.content_type, :access => :public_read )

                AWS::S3::S3Object.store( capture_path+"-thumb.jpg", thumbnail.read, aws_bucket, :content_type => 'image/jpeg', :access => :public_read )
                AWS::S3::S3Object.store( capture_path+"_geo_data.json", geo_data.read, aws_bucket, :content_type => 'text/json', :access => :public_read )
                if(AWS::S3::S3Object.exists?(@capture.token+"/"+@capture.token+media_file_name, aws_bucket) && capture_type=="video")
                    video = Panda::Video.new(:source_url => "http://s3.amazonaws.com/"+aws_bucket+"/"+@capture.token+"/"+@capture.token+media_file_name,
                      :path_format => @capture.token+'/'+@capture.token)
                    video.create
                    webm_encoding = video.encodings.create(:profile => "497ed598580820856c5c31045f3506da")
                    mp4_encoding = video.encodings.create(:profile => "609b26c991914477052337909ad2145a")
                    @capture.job_id = video.attributes['id']
                    @capture.webm_id = video.encodings[0].attributes['id']
                    @capture.mp4_id = video.encodings[1].attributes['id']
                end #encode video
                @r['data'] = @capture
            else
                @r = {:error => "true"}
            end
        else
            @r = {:error => "true", :message => "parameters incorrectly set"}
            @r['capture_info'] = params[:capture_info].nil?
            @r['media_file'] = params[:capture_info].nil?
            @r['geo_data'] = params[:media_file].nil?
            @r['thumbnail'] = params[:thumbnail].nil?
        end
        render :json => @r
    end
end
