# Skimming
Skimming is a gem for rails application that allows to filter a collection based on certain database-configurable rules. Every model can have its own rules towards every other model.
For example you can apply the feature to your Role model, so that every Role has individual filter rules for an association. It's useful expecially when you have to respond to an api call with a collection of records and you need it to be filtered differently based on which roles the authenticated user has.

## Installation
Inside your Gemfile put

    gem 'skimming'

and then run

    bundle install

In each model you want to have the feature, just put the following.

    include Skimming::Model

Once this config file is created, you can launch the following command.

    rails g skimming_migration

The command above will generate a migration file in your project. Now you can migrate.

    rails db:migrate

### Use skimming filters of another model

If you want, you can also allow a related model (for example User) to use Role's skimming rules. In that case the in the User model you should do as follows.

    skim_throught :roles

## Usage

Create one `Skimming::Item` for each class you want your skimmable models to skim. The name of the item has to be PascalCase.

    item = Skimming::Item.create(name: 'Order')

Create one `Skimming::Rule` for each condition you want to evaluate when you decide if the skimmable should keep the items of a certain collection.

    rule = Skimming::Rule.create(statement: '@order.created_at < 1.month.ago')

This, for example, hides all orders older than 1 month from the collection.

Create one `Skimming::Filter` for each item your model needs to skim and assign the rule.

    role.create_filter(item: item, rule: rule)

If now you call `role.skim orders_collection` only orders newer than 1 month ago will be returned.

Also user can do that if it has the role assigned and you have specified `skim_through :roles` in User model.

### Rules

You can store in filters rules whatever conditions you like in plain ruby and the string will be evaulated. Inside the rules, object have to be called as instance variables. These instance variables indeed need to be present and can be declared in a few ways.

1. The model name of the instance you called `skim` from, like the user, will be defined automatically based on model name, so if you call `user.skim rooms_collection` you will have `@user` variable defined.
2. Based on the skimmed collection, instance variables are defined. In the case above, `@order` variable will be present for each of the orders to be evaluated in. The collection name is calculated based on the class of the first object in the collection and will raise an error if is not the same for all collection elements. You can override this calculation specifying the `item_name` of the collection (the skimming will look for collection_filters with that `item_name`). This can be necessary if you are filtering throught different classes instances having STI.
3. You can pass as third argument an hash of objects like this `user.skim rooms_collection, time: Time.zone.now, whatever: @you_want` and you will have `@time` and `@whatever` variables defined for rule evaluation.

WARNING: since the strings get evaluated, i recommend not to allow anyone except project developers to create collection_filters, in order to prevent malicious code from being executed.
