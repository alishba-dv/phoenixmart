# Phoenixmart.Umbrella

Phoenix Mart

Phoenix Mart is a backend e-commerce system built with Phoenix Framework, Ecto, and PostgreSQL, with Swagger integration for API documentation. It provides features for user, product, order, and cart management.

# Features
User Management

User registration & login (JWT authentication)

Role-based access (Admin / Customer)

Profile management

Product Management

Admin can create, update, delete products

Customers can view, search, and filter products

Orders & Cart

Customers can create orders from cart

Admin can view and update order status

Cart management: add/remove products, update quantities

Reviews & Ratings

Customers can review purchased products

Admin can moderate reviews

Swagger Integration

Interactive API documentation with request/response schemas

Pagination

Paginated results for products, users, and orders using Scrivener

# Database Schema
# Users

id, name, email, password

Associations: many_to_many roles, has_many orders

# Roles

id, name (admin/customer)

Associations: many_to_many users

# Products

id, name, description, price, stock_quantity, category_id

# Categories

id, name

Associations: has_many products

# Orders

id, user_id, status, total_price, inserted_at

Associations: many_to_many products via order_items

# Order_Items

id, order_id, product_id, quantity, price

# Technologies Used

Elixir / Phoenix Framework – backend

Ecto – ORM and database migrations

PostgreSQL – relational database

Swagger / OpenAPI – API documentation

Scrivener – pagination

Setup Instructions

Clone the repository

git clone <repo_url>
cd phoenix_mart

```
# Install dependencies

mix deps.get


# Setup the database

mix ecto.create
mix ecto.migrate


# Start the server

mix phx.server


# Access Swagger UI

http://localhost:4000/swagger
```

Test API endpoints
Use Swagger UI or tools like Postman

# Folder Structure
lib/

├── phoenix_mart_web/    # Controllers, Views, API endpoints

├── phoenix_mart/        # Contexts and Schemas

priv/

└── repo/migrations/     # Database migrations

# Notes

Cascade Delete: Deleting a user removes entries in join tables (user_roles, user_businesses) but not the roles or businesses.

Preload Associations: Always preload roles and businesses before accessing them.