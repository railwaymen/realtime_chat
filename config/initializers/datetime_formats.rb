# frozen_string_literal: true

Time::DATE_FORMATS[:default] = ->(date) { date&.iso8601(3) }
