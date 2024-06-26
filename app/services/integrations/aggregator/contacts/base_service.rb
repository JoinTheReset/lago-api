# frozen_string_literal: true

module Integrations
  module Aggregator
    module Contacts
      class BaseService < Integrations::Aggregator::BaseService
        def action_path
          "v1/#{provider}/contacts"
        end

        private

        def headers
          {
            'Connection-Id' => integration.connection_id,
            'Authorization' => "Bearer #{secret_key}",
            'Provider-Config-Key' => provider
          }
        end

        def deliver_success_webhook(customer:)
          SendWebhookJob.perform_later(
            'customer.accounting_provider_created',
            customer
          )
        end
      end
    end
  end
end
