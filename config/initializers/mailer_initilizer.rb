# frozen_string_literal: true

# Register all main interceptors
Rails.application.config.action_mailer.interceptors = ['NonProdEmailInterceptor']
