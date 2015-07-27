module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PrzelewyDwaCztery
        autoload :Return,       File.dirname(__FILE__) + '/przelewy_dwa_cztery/return.rb'
        autoload :Helper,       File.dirname(__FILE__) + '/przelewy_dwa_cztery/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/przelewy_dwa_cztery/notification.rb'

        mattr_accessor :service_url
        self.service_url = 'https://secure.przelewy24.pl/trnVerify'

        def self.notification(post, options = {})
          Notification.new(post, options)
        end

        def self.return(post, options = {})
          Return.new(post, options)
        end
      end
    end
  end
end
