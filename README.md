# My Notes

# Code Review
Using enums leads to more and more conditional statements(for taxes, import duties, etc.). To make matters worse these conditionals end up living in the base Quote_Product model further cluttering its domain. We could move these into a concern but that is essentially equivalent to sweeping the dirt elsewhere. We still have a pattern that left unchecked will lead to bloat in our application.
## General
* `#FIXME` used to review original code and will be added in first commit
### Models

* `QuoteProduct`: poor naming - double ups with it's enum `product` column. product ideally to be moved into a separate table(advanced) or morph into Single Table Inheritance (STI) architecture(simpler) 
* double up validations for `amount`
* enum `products` column should be plural
* `QuoteProduct` model `if` methods: `case` logic can be also used, but if is preferable for rubocop. can also use `then` statement to make logic 1-liner
* `QuoteProduct``tax` method: poor naming - can be confused with tax rate
* `QuoteProduct` `import_duty` method: poor naming - can be confused with import duty rate
### Controllers
* unnecessary comments for CRUD app (routes, etc)
* set_quote method: poor naming. find_quote would be more appropriate
### Views
* `simple_form gem` can be a better alternative to standard form
### Specs
* empty tests
### Routes
* poor naming

# SOLUTION
The purpose is to make this better for the next developer so let’s do that by determining the preferred outcome through some introspective questioning. 
## Scenario 1 (create Separate table for products)
* separate 'product item' into a separate table with dedicated tax rates/costs/duties/etc
## Scenario 2 (breakdown products into separate classes and utilize STI)
* Reuse the existing Quote_Products table and allowing it to serve as a storage location for multiple 'item's and have them utilize Single Table Inheritance. https://guides.rubyonrails.org/association_basics.html#single-table-inheritance

In both implementations we need a new 'item' column on the existing table and to backfill older entries.

We will proceed with new table as it seems to be a cleaner and more future-proof solution

# Preferred Outcome

1. Quote_Product should stop relying on of the 'product' enum column and instead utilize a reference 'item' from a separate Item table with relevant data
2. New Item table should have a entry for each 'product' of quote_product and associated properties (cost, duties, taxes, etc.)
3. Quote_Product’s 'product' enum column should eventually be removed completely in favour of the new architecture.
# CHALLANGE: application Downtime
In a single deployment we add both a new column and the code that depends on it. During deployment there is a period of time where the new code is live before all the migrations have run. It is during this interval of waiting on the database that any users accessing the application will receive 500 errors from the new feature.
* **Solution**: adding a new column in one deploy and then on the subsequent one adding the code that uses the column there is no risk of exceptions.
# Migration strategy
1. Add a new database table called “Item” to enable referencing on the Quote_Product Table. seed this table accordingly.
2. Enable Quote_Product referencing `Item` table based on enum 'product'. Additionally, backfill existing Quote_Product data’s item column.
3. Start referring to 'Item' columns(tax,cost,duties) instead of QuoteProduct `IF` methods. Restrict using the old Quote_Product.product column.
4. With the application relying completely on the new table and the old `product` column disabled we can finally drop the quote_product.product column and any supporting code.
5. Add new item 'Blank Blue Ray Disks"

* at every step we need to ensure existing tests are passing and our app remains functional. Once we remove old features we need to adjust legacy tests accordingly
______

# ORIGIANAL README

Coding exercise application to Demostrate:
* Reading and understanding existing code
* Refactoring code for an upcoming feature change
* Adding the additional feature

# Product Description

This application allows Sales People to build quotes of office supplies.

# Current Products

Book            | $0.5 per item

Face masks      | $1 per item

First aid kits  | $10 per item

There is 10% tax rate on Books
There is a 5% import duty on Books and Face masks

# Your Tasks

## 1. Reading and understanding existing code

Get the application up and running.
Make notes on what you find good and bad about the code.
Please return your notes with the coding exercise.

## 2. Refactor and adding a new product

Add a new product of "Blank Blue-Ray Disks" with the following specifications:

* $2 per item
* Special tax rate of %2 
* no import duty

Your work will be evaluated to our internal coding standards, including criteria such as:
1. Class, method, and variable names
2. Top-down decomposition of algorithms
3. Best practice code layout
4. Effective file organisation
5. Correct exception handling
6. Good unit test cases
7. Object Orientation

## 3. All done

Please zip up your code and comments then email back.

# Setup and play with Cypress Test (Optional)

If you would like to see what we use for end to end testing you can attempt to get it running.

first start the rails server and leave it running

```shell
bin/rails s
```

in a new terminal

```shell
cd e2e
yarn install # this will take a good few minutes
yarn cypress open # then click "run 1 integration test"
```