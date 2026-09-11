# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

DENOMINATIONS = [
  "Roman Catholic (Latin)",
  "Syro-Malabar",
  "Syro-Malankara",
  "Malankara Orthodox",
  "Jacobite Syrian",
  "Mar Thoma",
  "Church of South India (CSI)",
  "Church of North India (CNI)",
  "Anglican",
  "Methodist",
  "Lutheran",
  "Baptist",
  "Brethren",
  "Pentecostal — Assemblies of God",
  "Pentecostal — IPC",
  "Pentecostal — Sharon",
  "Seventh-day Adventist",
  "Evangelical",
  "Non-denominational",
  "Other"
].freeze

DENOMINATIONS.each do |name|
  Denomination.find_or_create_by!(name: name)
end

puts "Seeded #{Denomination.count} denominations."
