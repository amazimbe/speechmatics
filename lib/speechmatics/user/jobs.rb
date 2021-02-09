# -*- encoding: utf-8 -*-

require 'mimemagic'

module Speechmatics
  class User::Jobs < API
    include Configuration

    def get(job_id)
      request(:get, "/jobs/#{job_id}")
    end

    def create(params={})
      attach_config(params)
      attach_audio(params)
      attach_text(params) if params[:text_file]
      super
    end

    def transcript(params)
      base_path = "/jobs/#{params[:job_id]}"
    
      if params[:format] == "txt"
        request(:get, "#{base_path}/transcript?format=txt")
      else
        request(:get, "#{base_path}/transcript")
      end
    end

    def alignment(params={})
      self.current_options = current_options.merge(args_to_options(params))
      request(:get, "#{base_path}/alignment")
    end

    def attach_config(params={})
      config = params.delete(:config)
      params[:config] = config.to_json
      params
    end

    def attach_audio(params={})
      file_path = params[:data_file]
      raise "No file specified for new job, please provide a :data_file value" unless file_path
      raise "No file exists at path '#{file_path}'" unless File.exist?(file_path)

      content_type = params[:content_type] || MimeMagic.by_path(file_path).to_s
      raise "No content type specified for file, please provide a :content_type value" unless content_type
      raise "Content type for file '#{file_path}' is not audio or video, it is '#{content_type}'." unless (content_type =~ /audio|video/)

      params[:data_file] = Faraday::UploadIO.new(file_path, content_type)
      params
    end

    def attach_text(params={})
      file_path = params[:text_file]
      raise "No file exists at path '#{file_path}'" unless File.exists?(file_path)
      params[:text_file] = Faraday::UploadIO.new(file_path, "text/plain; charset=utf-8",)
      params
    end

  end
end
