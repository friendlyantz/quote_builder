# README

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