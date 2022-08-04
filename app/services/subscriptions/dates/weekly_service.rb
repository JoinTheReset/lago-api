# frozen_string_literal: true

module Subscriptions
  module Dates
    class WeeklyService < Subscriptions::DatesService
      private

      def compute_base_date
        billing_date - 1.week
      end

      def compute_from_date
        if terminated_pay_in_arrear?
          return subscription.anniversary? ? previous_anniversary_day(billing_date) : billing_date.beginning_of_week
        end

        subscription.anniversary? ? previous_anniversary_day(base_date) : base_date.beginning_of_week
      end

      def compute_to_date
        return from_date.end_of_week if calendar?

        from_date + 6.days
      end

      def compute_charges_from_date
        from_date
      end

      def compute_next_end_of_period(date)
        return date.end_of_week if calendar?
        return date if date.wday == (subscription_date - 1.day).wday

        # NOTE: we need the last day of the period, and not the first of the next one
        date.next_occurring(subscription_day_name) - 1.day
      end

      def previous_anniversary_day(date)
        date.prev_occurring(subscription_day_name)
      end

      def subscription_day_name
        @subscription_day_name ||= subscription_date.strftime('%A').downcase.to_sym
      end
    end
  end
end
