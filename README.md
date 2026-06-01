# Online Store — Extension (CSEN 164 Assignment #2, Option A)

A Ruby on Rails 8 online store that extends the in-class demo store with user accounts,
user-scoped order history, and a full product reviews feature.

## Project Description

Online Store is a small but complete e-commerce application. Visitors can browse and
search products and read reviews. Registered users can add products to a session-based
cart, check out to create an order tied to their account, view their own order history,
and write/edit/delete reviews. An admin user can manage the product catalog and view
every customer's orders.

The project demonstrates Rails MVC, RESTful routing, ActiveRecord models and
associations, forms, session-based authentication (`has_secure_password`),
authorization, validations, and search/filtering.

## Main Features

- Product catalog with a public product detail page and an "Add to Cart" button.
- Product search on the index page (by name or description).
- User accounts: sign up, log in, log out, and persistent sessions.
- Session-based shopping cart (add, update quantity, remove, empty).
- Checkout that creates an order belonging to the logged-in user.
- Order history: users see only their own orders; admins see all orders.
- Product Reviews: rating (1–5) + comment, average rating on the product page,
  one review per user per product, edit/delete limited to the review's owner.
- Admin-only product management (create, edit, delete).

## Models and Associations

| Model     | Key fields                                  | Associations |
|-----------|---------------------------------------------|--------------|
| User      | name, email (unique), password_digest, admin | has_many :orders, has_many :reviews |
| Product   | name, description, price, image_url          | has_many :reviews, has_many :line_items |
| Cart      | (session-backed)                             | has_many :line_items |
| LineItem  | quantity                                     | belongs_to :product, belongs_to :cart (optional), belongs_to :order (optional) |
| Order     | name, address, status                        | belongs_to :user, has_many :line_items |
| Review    | rating, comment                              | belongs_to :user, belongs_to :product |

```
User ──< Order ──< LineItem >── Product
User ──< Review >── Product
Cart ──< LineItem >── Product
```

## CRUD Coverage

- **Products** — full admin CRUD (create / read / update / delete).
- **Reviews** — full user CRUD (users manage only their own reviews).

## Requirements Mapping

- **Authentication** — sessions + `has_secure_password`, with a `current_user` helper.
- **Authorization** — users cannot view other users' orders or edit others' reviews;
  product management and viewing all orders is admin-only.
- **Validations** — presence/uniqueness/format on users, price numericality on products,
  rating inclusion (1..5) on reviews, etc. Invalid forms re-render with error messages.
- **Search/Filtering** — `Product.search(query)` on the product index.
- **Seed Data** — `db/seeds.rb` creates users, products, reviews, and orders.

## Tech Stack

- Ruby 4.0.x, Rails 8.1
- SQLite database
- Importmaps + Hotwire (Turbo/Stimulus), Propshaft assets

## Getting Started

```bash
# Install dependencies
bundle install

# Set up the database and load sample data
bin/rails db:prepare
bin/rails db:seed

# Start the server
bin/rails server
```

Then visit http://localhost:3000.

## Sample Logins

All seeded accounts use the password `password`.

| Role  | Email               | Password |
|-------|---------------------|----------|
| Admin | admin@example.com   | password |
| User  | alice@example.com   | password |
| User  | bob@example.com     | password |
| User  | carol@example.com   | password |

- Log in as **admin** to add/edit/delete products and view all orders.
- Log in as a **regular user** to shop, check out, and write reviews.

## Known Limitations

- Cart is stored per browser session (not persisted to a logged-in user across devices).
- No real payment processing; checkout simply records an order.
- Order status is set in seeds/checkout but there is no admin UI to change it.
- Product images are referenced by URL (placeholder images by default).

## Deployment

The application is deployed to AWS on a single EC2 instance (Graviton/arm64,
Ubuntu) using [Kamal](https://kamal-deploy.org), with the container image stored
in Amazon ECR and the SQLite databases on a persistent Docker volume.

**Live link:** http://35.161.45.210

Redeploying after code changes:

```bash
# Requires Docker (colima), the AWS CLI, and the railsstore SSH key in ssh-agent
bin/kamal deploy
```

### Tearing down AWS resources (to stop any further cost)

```bash
# Stop and remove the app from the server
bin/kamal remove

# Then terminate the AWS resources
aws ec2 terminate-instances --instance-ids <instance-id>
aws ec2 release-address --allocation-id <eip-allocation-id>
aws ec2 delete-security-group --group-name railsstore-sg
aws ec2 delete-key-pair --key-name railsstore
aws ecr delete-repository --repository-name railsstore --force
```

### Github Repo
https://github.com/PatPrograming/csen164-online-store

