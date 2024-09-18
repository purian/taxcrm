class AddMissingAttributesToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :Website, :string
    add_column :clients, :PhoneNumber2, :string
    add_column :clients, :Source, :string
    add_column :clients, :OtherSource, :string
    add_column :clients, :Fax, :string
    add_column :clients, :Heirs, :boolean
    add_column :clients, :NumberOfHeirs, :integer
    add_column :clients, :Comment, :text
    add_column :clients, :State, :string
    add_column :clients, :City, :string
    add_column :clients, :Address, :string
    add_column :clients, :StatusId, :string
    add_column :clients, :FamilyStatus, :string
    add_column :clients, :PropertyTypeSold, :string
    add_column :clients, :SoldProperty6Years, :string
    add_column :clients, :Industry, :string
    add_column :clients, :AdditionalAsset, :string
    add_column :clients, :AdditionalSellers, :string
    add_column :clients, :WorkStatus, :string
    add_column :clients, :LeadStatusId, :string
    add_column :clients, :AccountIsHanicapped, :string
    add_column :clients, :TaxType, :string
    add_column :clients, :DocStatus, :string
    add_column :clients, :AddressOfSale, :string
    add_column :clients, :AverageIncome, :string
    add_column :clients, :AverageIncomePartner, :string
    add_column :clients, :DivorceYear, :string
    add_column :clients, :YearOfSale, :string
    add_column :clients, :LawyerComissionPayed, :boolean
    add_column :clients, :SpouseID, :string
    add_column :clients, :Lawyers, :string
    add_column :clients, :ChangedLeadToClient, :string
    add_column :clients, :Rentpayment, :string
    add_column :clients, :NeedPromotion, :string
    add_column :clients, :mizrhai, :boolean
    add_column :clients, :Clalit, :boolean
    add_column :clients, :DiscountBank, :boolean
    add_column :clients, :ChangingLead, :string
    add_column :clients, :migdal, :boolean
    add_column :clients, :mortgage, :decimal, precision: 10, scale: 2
    add_column :clients, :last_details_scraped_at, :datetime
  end
end
