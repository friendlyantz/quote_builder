# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts Item.destroy_all ? "purge success" : "purge failed"
book = Item.new(
              name: "Book",
              individual_cost: 0.5,
              tax_rate: 0.1,
              import_duty_rate: 0.05
)

puts book.save ?  "success" : "failed"

face_mask = Item.new(
              name: "Face mask",
              individual_cost: 1,
              import_duty_rate: 0.05
)
puts face_mask.save ? "success" : "failed"

first_aid_kit = Item.new(
              name: "First aid kit",
              individual_cost: 10
)
puts first_aid_kit.save ? "success" : "failed"

blank_blue_ray_disk = Item.new(
              name: "Blank Blue-Ray Disk",
              individual_cost: 2,
              tax_rate: 0.02
)
puts blank_blue_ray_disk.save ? "success" : "failed"
