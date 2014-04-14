# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(first_name: "Eylam",
            last_name: "Keshet",
            username: "eylkes",
            email: "d@jk.com",
            password: "123",
            password_confirmation: "123",
            instrument: "Violin",
            admin: false)
