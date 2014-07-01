module Bitly
  module V3
    class Bundle
      attr_reader :bundle_owner, :created_ts, :description, :title, :bundle_link, :last_modified_ts, :private, :links

      def initialize options
        @bundle_owner       = options['bundle_owner']
        @created_ts         = options['created_ts']
        @description        = options['description']
        @title              = options['title']
        @private            = options['private']
        @last_modified_ts   = options['last_modified_ts']
        @bundle_link        = options['bundle_link']
        @links              = (options['links'] ? options['links'].map { |link_data| Bitly::V3::Url.new(nil, link_data) } : [])
      end
    end
  end
end
