# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 100.times.with_index do |i|
#   vid = Video.new(title: "test #{i}", description: "")
#   vid.clip.attach(
#     io: File.open("/mnt/c/Users/Santonero/Pictures/Big_Buck_Bunny_Trailer(s).mp4"),
#     filename: "Big_Buck_Bunny_Trailer(s).mp4",
#     content_type: "video/mp4")
#   vid.thumbnail.attach(
#     io: File.open("/mnt/c/Users/Santonero/Pictures/eagerload.PNG"),
#     filename: "eagerload.PNG",
#     content_type: "image/png")
#   vid.save
#   puts "Created video #{i + 1}"
# end
