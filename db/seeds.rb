# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

require 'rest-client'
require 'json'

# Clear existing data
Post.destroy_all

# Fetch data from JSONPlaceholder API
response = RestClient.get('https://jsonplaceholder.typicode.com/posts')
posts_data = JSON.parse(response.body)

# Create posts in the database
posts_data.each do |post_data|
  Post.create(
    title: post_data['title'],
    body: post_data['body']
  )
end

puts "#{Post.count} posts created!"
