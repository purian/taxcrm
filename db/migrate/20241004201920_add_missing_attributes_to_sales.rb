class AddMissingAttributesToSales < ActiveRecord::Migration[6.1]
  def change
    change_table :sales do |t|
      t.string :LeadIrrelevantReason
      t.string :FieldAgent
      t.string :TaxType
      t.string :LeadStatusId
      t.boolean :Clientconfidentiality
      t.string :LeadOwnerId
      t.string :ChangingLead
      t.string :Lawyers
      t.string :ChangedLeadToClient
      t.string :FamilyStatus
      t.string :WorkStatus
      t.string :YearOfSaleNew
      t.string :AdditionalSellers
      t.boolean :redemption
      t.boolean :Futuresale
      t.string :KidsUnder18
      t.string :PropertyTypeSold
      t.string :AccountIsHanicapped
      t.boolean :accident
      t.boolean :NeedPromotion
      t.string :CAPStatus
    end
  end
end