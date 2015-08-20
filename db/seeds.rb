# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create({name: 'Matthew', email: 'matthew@thespainreport.com', password: 'spain', password_confirmation: 'spain'})
u2 = User.create({name: 'John', email: 'john@example.com', password: 'spain', password_confirmation: 'spain'})
u3 = User.create({name: 'Mary', email: 'mary@example.com', password: 'spain', password_confirmation: 'spain'})
