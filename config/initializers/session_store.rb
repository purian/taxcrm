Rails.application.config.session_store :active_record_store,
  key: '_tax_crm_session',
  expire_after: 30.days,
  httponly: true,
  secure: Rails.env.production?,
  same_site: :lax