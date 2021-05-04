# My Notes

# Code Review
Using enums leads to more and more conditional statements(for taxes, import duties, etc.). To make matters worse these conditionals end up living in the base Quote_Product model further cluttering its domain. We could move these into a concern but that is essentially equivalent to sweeping the dirt elsewhere. We still have a pattern that left unchecked will lead to bloat in our application.
## General
* `Hashtag FIXME` used to review original code and will be added to the first commit
* SQL Lite DB used. Postgres is much better option and industry standard 
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
* `@quote_product.quote_id = params[:quote_id]`: direct params assign could be unsafe. better use Quote.find(params[:quote_id])

### Views
* Quote can't be destroyed
* `simple_form gem` can be a better alternative to standard form
* financial data can be rounded to 2 decimals
* qty can be be inputed as negative from UX perspective - shopuld be positive to match backend
### Specs
* empty tests
### Routes
* poor naming and unneccessary redirection
* redirection causes minor warnings for e2e
### Tests
* Factories empty
* Decorator/Draper test empty
* No rout testing 
* No controller testing
* Request specs should be called quote_products_request_spec to avoid confusion with model spec which have almost identical name 

### MISC
* Draper gem used: this gem is integrated deeply in rails, and might require some wait for draper to be updated to be comparable with latest rails if we decide to update rails

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

* at every step we need to ensure existing tests are passing and our app remains functional. Once we remove old features we need to adjust legacy tests accordingly
## Phase 1: Add a new database table called Item AND add references to the Quote_Product table
Note: 
- [x] One thing to avoid at this point is adding a not: null constraint to the new 'item' field. The reason for this is because 'item' doesn't have valid data yet and setting a constraint will only force it to throw exceptions everywhere.

### App also need to start referencing new Item table based on current product enum name

we can either seed the DB with appropriate products and use find_by to match with enum `product or create Items automatically. 

Seeding seems to be a safer option as we can narrow down options and modify them later.

## Phase 2a:  Start assigning newly generated QuoteProduct to Items table
create concern with before callback
```ruby
# This should be removed once QuoteProduct.product is not longer necessary
module SyncQuoteProductItem
  extend ActiveSupport::Concern

  included do
    before_validation :sync_product_item
  end

  def sync_product_item
    self.item = Item.find_by(name: product.to_s.humanize) unless product.nil?
  end
end

```
## Phase 2b: Backfill existing records that use 'product' enum and still do not have 'Item' reference yet
The last part of this phase is to backfill the existing data. We can do this with a migration that updates batches of records at a time. The reason for using batches is that if you have say hundreds of thousands of QuoteProduct records trying to update them all at once might leave your database locked up. Again this could lead to downtime for your users which we’d like to avoid here.

Note: All migration should be reversible
we also ensure that rails db:rollback works without issue. When code is anticipated in the future to be removed but is required for a migration to work, like below, re-implementing the logic directly in the migration allows for the migration to always work. This is regardless of the application's implementation.

```ruby
class BackfillItemRefBasedOnExistingProductEnumData < ActiveRecord::Migration[6.1]
  # Disables the standard Rails transaction that is wrapped around each
  # migration. For this migration we're pretty safe in that we're updating in
  # batches using an update_all statement.
  disable_ddl_transaction!

  # We are re-implementing this class here for a good reason! Eventually
  # QuoteProduct's product will be completely removed from the application meaning that
  # if we just used QuoteProduct.product in the below code it wouldn't work. This
  # situation would only occur for new development environment setup's of the
  # application. It is a best practice to keep your migrations as reversible as possible.
  class QuoteProduct < ApplicationRecord
    enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }
  end

  def up
    puts 'item backfill running up'
    QuoteProduct.products.keys.each do |product|
      update_product(product)
    end
  end

  def down
    puts 'item backfill running rollback'
    QuoteProduct.products.keys.each do |product|
      nullify_product(product)
    end
  end

  private

  def update_product(product)
    p item = Item.find_by(name: product.to_s.humanize)

    QuoteProduct.send(product.to_sym).where(item_id: nil).in_batches do |product_batch|
      p product_batch.update_all(item_id: item.id)
    rescue byebug
    end
  end

  def nullify_product(product)
    QuoteProduct.send(product.to_sym).where.not(item_id: nil).in_batches do |product_batch|
      p product_batch.update_all(item_id: nil)
    end
  end
end

```
Additionally, at this point we can really lock down the item column by adding a database level not: null constraint. This prevents new records from being created or updated if the item column is empty.
```ruby
class AddNullConstraintToItemColumnOnQuoteProductsTable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :quote_products, :item, false
  end
end
```
Once we’ve deployed the above phase, we can have complete confidence that all of our QuoteProducts have their item_id reference column filled out.
## Phase 3: Start referring to 'Item' columns(tax,cost,duties) instead of QuoteProduct `IF` methods. Restrict using the old Quote_Product.product column.

- [x] Now that we have a fully working `Quote - QuoteProduct - Item` architecture we can begin to move logic into type specific locations.
- [x] We also want to move away from relying on the SyncQuoteProductItem’s callback and instead have the system work properly.

## Phase 4: With the application relying completely on the new table and the old `product` column disabled we can finally drop the quote_product.product column and any supporting code.

- [x] Now database that contains accurate data and all future record creations refer Items from a separate table. Additionally, we have disallowed writing to the old column which allows us to safely remove it from the system. This also means that the system is prepared to function without the column existing. So the only things left are to write a migration to drop the beer_type column and remove the SyncBeerType.
- [x] cleanup code, update readme
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