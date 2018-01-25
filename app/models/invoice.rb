class Invoice < ActiveRecord::Base
	belongs_to :user
	belongs_to :subscription
	
	before_update :check_invoice_for_date
	
	scope :thisyear, -> {where(:created_at => (Time.current.year))}
	scope :spain, -> {where(:stripe_invoice_ip_country_code => 'ES')}
	scope :notspain, -> {where.not(:stripe_invoice_ip_country_code => 'ES')}
	
	private
	def check_invoice_for_date
		if self.invoice_for_changed?
			self.invoice_for_date = Time.current
		else
		end
	end
	
end
