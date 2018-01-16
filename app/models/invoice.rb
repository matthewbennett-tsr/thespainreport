class Invoice < ActiveRecord::Base
	belongs_to :user
	belongs_to :subscription
	
	before_update :check_invoice_for_date
	
	private
	def check_invoice_for_date
		if self.invoice_for_changed?
			self.invoice_for_date = Time.current
		else
		end
	end
	
end
