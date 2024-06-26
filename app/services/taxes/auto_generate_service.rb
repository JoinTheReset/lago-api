# frozen_string_literal: true

module Taxes
  class AutoGenerateService < BaseService
    def initialize(organization:)
      @organization = organization
      @lago_eu_vat = LagoEuVat::Rate.new
      super
    end

    def call
      countries_code = lago_eu_vat.countries_code

      countries_code.each do |country_code|
        create_country_tax(country_code)
      end

      create_generic_taxes
    end

    private

    attr_reader :organization, :lago_eu_vat

    def create_country_tax(country_code)
      country_rates = lago_eu_vat.country_rates(country_code:)
      tax_code = "lago_eu_#{country_code.downcase}_standard"
      tax_name = "Lago EU #{country_code.upcase} Standard"

      create_tax(tax_code, tax_name, country_rates['standard'])
    end

    def create_generic_taxes
      create_tax('lago_eu_reverse_charge', 'Lago EU Reverse Charge', 0.0)
      create_tax('lago_eu_tax_exempt', 'Lago EU Tax Exempt', 0.0)
    end

    def create_tax(tax_code, tax_name, rate)
      tax = organization.taxes.find_or_initialize_by(
        code: tax_code
      )

      tax.name = tax_name
      tax.rate = rate
      tax.description = 'Generated By Lago EU VAT management'
      tax.auto_generated = true

      tax.save!
    end
  end
end
