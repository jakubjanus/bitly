module Bitly
  module V3
    module Apis
      module Bundle
        class BundleNotFound < BitlyError; end
        class LinkNotFound < BitlyError; end
        class AlreadyInBundle < BitlyError; end

        def bundle_archive bundle_link
          get bundle_path('archive'), :query => { :bundle_link => bundle_link }
          true
        end

        def bundle_bundles_by_user user
          response = get bundle_path('bundles_by_user'), :query => { :user => user }
          response['data']['bundles'].map { |data| Bitly::V3::Bundle.new(data) }
        end

        def bundle_create options = {}
          options.reject! { |k, v| ![:title, :private, :description].include?(k.to_sym) }
          response = get bundle_path('create'), :query => options
          Bitly::V3::Bundle.new(response['data']['bundle'])
        end

        def bundle_contents bundle_link
          response = get bundle_path('contents'), :query => { :bundle_link => bundle_link }
          Bitly::V3::Bundle.new response['data']['bundle']
        end

        def bundle_link_add bundle_link, link, options = {}
          options.reject! { |k, v| k.to_sym != :title }
          response = get bundle_path('link_add'), :query => options.merge({ :bundle_link => bundle_link, :link => link })
          Bitly::V3::Bundle.new(response['data']['bundle']).links.find { |l| l.long_url == link }
        rescue BitlyError => e
          if e.code == 404
            raise BundleNotFound.new("Bundle not found", 404)
          elsif e.code == 500 && /LINK_ALREADY_IN_BUNDLE/ === e.message
            raise AlreadyInBundle.new("Link already in bundle", 500)
          else
            raise e
          end
        end

        def bundle_link_remove bundle_link, link
          response = get bundle_path('link_remove'), :query => { :bundle_link => bundle_link, :link => link }
          Bitly::V3::Bundle.new response['data']['bundle']
        rescue BitlyError => e
          if /INVALID_ARG_LINK/ === e.message
            raise LinkNotFound.new "Link not found", e.code
          else
            raise e
          end
        end


        private

        def bundle_path endpoint
          "/bundle/#{endpoint}"
        end
      end
    end
  end
end