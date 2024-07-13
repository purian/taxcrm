# db/migrate/XXXXXX_add_details_to_leads.rb
class AddDetailsToLeads < ActiveRecord::Migration[6.1]
  def change
    add_column :leads, :Website, :string
    add_column :leads, :LeadOwnerId_objectId, :string
    add_column :leads, :LeadOwnerId_username, :string
    add_column :leads, :LeadOwnerId_active, :boolean
    add_column :leads, :LeadOwnerId_job, :string
    add_column :leads, :LeadOwnerId_phone, :string
    add_column :leads, :LeadOwnerId_extension, :string
    add_column :leads, :PhoneNumber2, :string
    add_column :leads, :Fax, :string
    add_column :leads, :State, :string
    add_column :leads, :City, :string
    add_column :leads, :Address, :string
    add_column :leads, :Comment, :text
    add_column :leads, :Heirs, :boolean
    add_column :leads, :AcademicDetails, :text
    add_column :leads, :AlimonyDetails, :text
    add_column :leads, :ArmyDischargeDetails, :text
    add_column :leads, :DonationDetails, :text
    add_column :leads, :FamilyDisabilityDetails, :text
    add_column :leads, :HandicappedDetails, :text
    add_column :leads, :HospitalDetails, :text
    add_column :leads, :ImmigrationCardDetails, :text
    add_column :leads, :NotWorkingDetails, :text
    add_column :leads, :PensionDepositDetails, :text
    add_column :leads, :PensionDetails, :text
    add_column :leads, :ReservesDetails, :text
    add_column :leads, :SecuritiesDetails, :text
    add_column :leads, :UnemploymentFeeDetails, :text
    add_column :leads, :LeadStatusId_objectId, :string
    add_column :leads, :TaxType_objectId, :string
    add_column :leads, :TaxType_Name, :string
    add_column :leads, :Number2, :integer
    add_column :leads, :Campaign, :string
    add_column :leads, :AddressOfSale, :string
    add_column :leads, :AverageIncome, :string
    add_column :leads, :AverageIncomePartner, :string
    add_column :leads, :DivorceYear, :string
    add_column :leads, :YearOfSale, :string
    add_column :leads, :SpouseID, :string
  end
end