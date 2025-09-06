# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def random_image_url
  "https://picsum.photos/seed/#{rand(1000)}/150"
end

# Seed Products
Product.create(name: 'Widget', description: 'A useful widget', price: 19.99, img_url: random_image_url)
Product.create(name: 'Gadget', description: 'A fancy gadget', price: 29.99, img_url: random_image_url)
Product.create(name: 'Doodad', description: 'A nifty doodad', price: 9.99, img_url: random_image_url)
Product.create(name: 'Thingamajig', description: 'An interesting thingamajig', price: 14.99, img_url: random_image_url)
Product.create(name: 'Contraption', description: 'A complex contraption', price: 49.99, img_url: random_image_url)
Product.create(name: 'Gizmo', description: 'A cool gizmo', price: 24.99, img_url: random_image_url)
Product.create(name: 'Expensive Item', description: 'An expensive item', price: 99.99, img_url: random_image_url)
Product.create(name: 'Smart Watch', description: 'Track your fitness and notifications', price: 129.99,
               img_url: random_image_url)
Product.create(name: 'Bluetooth Speaker', description: 'Portable audio with deep bass', price: 59.99,
               img_url: random_image_url)
Product.create(name: 'Wireless Earbuds', description: 'Crystal clear sound without wires', price: 89.99,
               img_url: random_image_url)
Product.create(name: 'Laptop Stand', description: 'Ergonomic height adjustment for comfort', price: 34.99,
               img_url: random_image_url)
Product.create(name: 'Mechanical Keyboard', description: 'Tactile typing experience', price: 79.99,
               img_url: random_image_url)
Product.create(name: 'USB-C Hub', description: 'Connect all your devices', price: 45.99, img_url: random_image_url)
Product.create(name: 'Desk Lamp', description: 'Adjustable lighting for your workspace', price: 39.99,
               img_url: random_image_url)
Product.create(name: 'Wireless Mouse', description: 'Precision pointing device', price: 29.99,
               img_url: random_image_url)
Product.create(name: 'External SSD', description: 'Fast portable storage', price: 119.99, img_url: random_image_url)
Product.create(name: 'Phone Stand', description: 'Hands-free viewing', price: 15.99, img_url: random_image_url)

# Seed Orders
Order.create(user_id: 1, product_id: 1, quantity: 2)
Order.create(user_id: 1, product_id: 2, quantity: 1)
Order.create(user_id: 2, product_id: 3, quantity: 5)
Order.create(user_id: 2, product_id: 4, quantity: 3)

# Seed Flag
ThisIsVerySecretLongTableName.create(content: 'Flag{C0ngr4ts_on_y0ur_f1rst_Rails_challenge}')
