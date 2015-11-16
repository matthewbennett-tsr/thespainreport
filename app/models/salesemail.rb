class Salesemail < ActiveRecord::Base
  scope :readers, -> {where(:to => 'reader')}
  scope :subscribers, -> {where(:to => 'subscriber')}
  scope :minutes, -> {where(delay_period: 'minutes')}
  scope :hours, -> {where(delay_period: 'hours')}
  scope :days, -> {where(delay_period: 'days')}
  scope :one, -> {where(delay_number: '1')}
  scope :two, -> {where(delay_number: '2')}
  scope :three, -> {where(delay_number: '3')}
  scope :four, -> {where(delay_number: '4')}
  scope :five, -> {where(delay_number: '5')}
  scope :six, -> {where(delay_number: '6')}
  scope :seven, -> {where(delay_number: '7')}
  scope :eight, -> {where(delay_number: '8')}
  scope :nine, -> {where(delay_number: '9')}
  scope :ten, -> {where(delay_number: '10')}
  scope :eleven, -> {where(delay_number: '11')}
  scope :twelve, -> {where(delay_number: '12')}
  scope :thirteen, -> {where(delay_number: '13')}
  scope :fourteen, -> {where(delay_number: '14')}
  scope :fifteen, -> {where(delay_number: '15')}
  scope :sixteen, -> {where(delay_number: '16')}
  scope :seventeen, -> {where(delay_number: '17')}
  scope :eighteen, -> {where(delay_number: '18')}
  scope :nineteen, -> {where(delay_number: '19')}
  scope :twenty, -> {where(delay_number: '20')}
  scope :twentyone, -> {where(delay_number: '21')}
  scope :twentytwo, -> {where(delay_number: '22')}
  scope :twentythree, -> {where(delay_number: '23')}
  scope :twentyfour, -> {where(delay_number: '24)'}
  scope :twentyfive, -> {where(delay_number: '25')}
  scope :twentysix, -> {where(delay_number: '26')}
  scope :twentyseven, -> {where(delay_number: '27')}
  scope :twentyeight, -> {where(delay_number: '28')}
  scope :twentynine, -> {where(delay_number: '29')}
  scope :thirty, -> {where(delay_number: '30')}
  scope :thirtyone, -> {where(delay_number: '31')}
end