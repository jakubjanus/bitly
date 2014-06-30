module Bitly
  module V3
    module Apis
      module Bundle
        def bundle_archive bundle_link
          get bundle_path('archive'), :query => { :bundle_link => bundle_link }
          true
        end

        def bundle_bundles_by_user user

        end

        def bundle_create options = {}
          options.reject! { |k, v| ![:title, :private, :description].include?(k.to_sym) }
          response = get bundle_path('create'), :query => options
          return Bitly::V3::Bundle.new(response['data']['bundle'])
        end

        def bundle_contents bundle_link

        end

        def bundle_link_add

        end

        def bundle_link_remove

        end


        private

        def bundle_path endpoint
          "/bundle/#{endpoint}"
        end
      end
    end
  end
end