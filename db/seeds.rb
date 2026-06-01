# Seed data for the Rails Store demo.
# Run with: bin/rails db:seed (idempotent — clears existing data first).

puts "Clearing existing data..."
Review.destroy_all
LineItem.destroy_all
Order.destroy_all
Product.destroy_all
Cart.destroy_all
User.destroy_all

puts "Creating users..."
admin = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  admin: true
)

alice = User.create!(name: "Alice Nguyen", email: "alice@example.com", password: "password", password_confirmation: "password")
bob   = User.create!(name: "Bob Martinez", email: "bob@example.com",   password: "password", password_confirmation: "password")
carol = User.create!(name: "Carol Smith",  email: "carol@example.com", password: "password", password_confirmation: "password")

regular_users = [alice, bob, carol]

puts "Creating products..."
products_data = [
  { name: "Mechanical Keyboard", price: 89.99, description: "A tactile mechanical keyboard with hot-swappable switches and RGB backlighting.", image_url: "https://placehold.co/600x450?text=Keyboard" },
  { name: "Wireless Mouse", price: 39.99, description: "Ergonomic wireless mouse with a precise optical sensor and long battery life.", image_url: "https://placehold.co/600x450?text=Mouse" },
  { name: "27-inch Monitor", price: 249.00, description: "A 27-inch 1440p IPS monitor with thin bezels and great color accuracy.", image_url: "https://placehold.co/600x450?text=Monitor" },
  { name: "USB-C Hub", price: 29.95, description: "7-in-1 USB-C hub with HDMI, USB-A, SD card reader, and power passthrough.", image_url: "https://placehold.co/600x450?text=USB-C+Hub" },
  { name: "Noise-Cancelling Headphones", price: 159.99, description: "Over-ear headphones with active noise cancellation and 30-hour battery.", image_url: "https://placehold.co/600x450?text=Headphones" },
  { name: "Laptop Stand", price: 34.50, description: "Aluminum laptop stand that improves posture and airflow.", image_url: "https://placehold.co/600x450?text=Laptop+Stand" },
  { name: "Webcam 1080p", price: 54.00, description: "Full HD webcam with autofocus and a built-in privacy shutter.", image_url: "https://placehold.co/600x450?text=Webcam" },
  { name: "Desk Lamp", price: 27.99, description: "Dimmable LED desk lamp with adjustable color temperature.", image_url: "https://placehold.co/600x450?text=Desk+Lamp" }
]

products = products_data.map { |attrs| Product.create!(attrs) }

puts "Creating reviews..."
review_comments = [
  "Absolutely love it, works great!",
  "Good value for the price.",
  "Does the job, but could be better.",
  "Exceeded my expectations.",
  "Solid build quality and easy to use."
]

products.each do |product|
  regular_users.sample(rand(1..3)).each do |user|
    Review.create!(
      product: product,
      user: user,
      rating: rand(3..5),
      comment: review_comments.sample
    )
  end
end

puts "Creating orders..."
[alice, bob].each do |user|
  2.times do
    order = user.orders.build(
      name: user.name,
      address: "#{rand(100..999)} Market St, San Jose, CA",
      status: Order::STATUSES.sample
    )
    products.sample(rand(1..3)).each do |product|
      order.line_items.build(product: product, quantity: rand(1..2))
    end
    order.save!
  end
end

puts "Seeding complete!"
puts "  Users:    #{User.count} (admin: admin@example.com / password)"
puts "  Products: #{Product.count}"
puts "  Reviews:  #{Review.count}"
puts "  Orders:   #{Order.count}"
