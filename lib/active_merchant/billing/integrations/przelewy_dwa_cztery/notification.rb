require 'net/http'
require 'time'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PrzelewyDwaCztery
        class Notification < ActiveMerchant::Billing::Integrations::Notification

          #przelewy24 nie wysylaja zadnego statusu. dla niepopranej odpowiedzi nie ma zadnego requesta
          def status
            params['p24_statement'].present?
          end

          # Id of this transaction (paypal number)
          def transaction_id
            params['p24_statement']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['p24_amount']
          end

          def complete?
            sparams['p24_statement'].present?
          end

          def currency
            orginal_amount.split(' ')[1]
          end

          def key=(value)
            @options[:key] = value
          end


          def test?
            # params['t_id'].match('.*-TST\d+') ? true : false
          end

          PAYMENT_HOOK_FIELDS = [
              :p24_merchant_id,
              :p24_pos_id,
              :p24_session_id,
              :p24_amount,
              :p24_currency,
              :p24_order_id,
              :p24_method,
              :p24_statement,
              :p24_sign
          ]

          PAYMENT_HOOK_SIGNATURE_FIELDS = [
              :p24_session_id,
              :p24_order_id,
              :p24_amount,
              :p24_currency
          ]

          VERIFY_HOOK_SIGNATURE_FIELDS = [
              :p24_session_id,
              :p24_order_id,
              :p24_amount,
              :p24_currency
          ]

          # Provide access to raw fields
          PAYMENT_HOOK_FIELDS.each do |key|
            define_method(key.to_s) do
              params[key.to_s]
            end
          end

          def generate_signature_string
            PAYMENT_HOOK_SIGNATURE_FIELDS.map { |key| params[key.to_s] } * "|" + "#{@options[:key]}"
          end

          def generate_signature_verify
            VERIFY_HOOK_SIGNATURE_FIELDS.map { |key| params[key.to_s] } * "|" + "#{@options[:key]}"
          end

          def generate_signature(verify = false)
            Digest::MD5.hexdigest(verify ? generate_signature_verify : generate_signature_string)
          end

          def acknowledge(authcode = nil)
            generate_signature.to_s == md5.to_s
          end
        end
      end
    end
  end
end
