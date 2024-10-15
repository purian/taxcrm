require 'net/http'
require 'uri'
require 'json'

class ExternalDetailsController < ApplicationController
  def sync_to_crm
    Rails.logger.debug "Starting sync_to_crm process"
    details_to_sync = ExternalDetail.where(is_valid: true, sync_at: nil)
    Rails.logger.debug "Found #{details_to_sync.count} details to sync"

    crm_service = CrmSyncService.new
    Rails.logger.debug "Created CrmSyncService instance"

    synced_count = 0
    details_to_sync.each do |detail|
      Rails.logger.debug "Attempting to sync detail ID: #{detail.id}"
      if crm_service.sync_detail(detail)
        detail.update(sync_at: Time.current)
        synced_count += 1
        Rails.logger.debug "Successfully synced and updated detail ID: #{detail.id}"
      else
        Rails.logger.debug "Failed to sync detail ID: #{detail.id}"
      end
    end

    Rails.logger.debug "Sync process completed. Synced count: #{synced_count}"
    redirect_to all_external_details_path, notice: "Sync process completed. #{synced_count} out of #{details_to_sync.count} records were successfully synced."
  end
end
