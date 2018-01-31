class AddSpainCcFieldsToUser < ActiveRecord::Migration
	def change
		add_column :users, :credit_card_id_spain, :string
		add_column :users, :credit_card_brand_spain, :string
		add_column :users, :credit_card_country_spain, :string
		add_column :users, :credit_card_last4_spain, :string
		add_column :users, :credit_card_expiry_month_spain, :integer
		add_column :users, :credit_card_expiry_year_spain, :integer
	end
end