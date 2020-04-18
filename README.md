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

Create `config/skimming.yml` file in your project and compile it as follows for each of the models you included the code above into (let's say for instance you included Skimming::Model into Role model).

    associations:
      roles:
        class_name: 'Role'

Once this config file is created, you can launch the following command.

    rails g skimming_migration

The command above will generate a migration file in your project. Now you can migrate.

    rails db:migrate

### Use skimming filters of another model

If you want, you can also allow a related model (for example User) to use Role's skimming rules. In that case the User model should have this instead.

    include Skimming::ParasiteModel

And the config file should have one more configuration.

    associations:
      roles:
        class_name: 'Role'
    options:
      user:
        skim_through:
          - 'roles'

## Usage

Create one `Skimming::CollectionFilter` for each class your model needs to skim and assign a rule that has to be satisfied.

    role.create_collection_filter(object_name: 'order', rule: '@order.complete?')
    role.create_collection_filter(object_name: 'pet', rule: '@pet.nice?')
    role.create_collection_filter(object_name: 'room', rule: '@room.clean?')

You could also assign the same `Skimming::CollectionFilter` to multiple roles since they have a HABTM relation.

If now you call `role.skim rooms_collection` only clean rooms will be returned.

Also user can do that if it has the role assigned. By default the parasite model skims through all its associated models that have included `Skimming::Model` and sums all results, rejecting the records that all of the skimming models have rejected (if any of the skimming models have the record present in the filter, it will be present in the parasite model skimming result). However in some cases you may want to make the parasite model to skim only through one or some of these models. To do so, just pass one of the models or an array of those.

    user.skim rooms_collection, through: :roles
    user.skim rooms_collection, through: [:roles, :whatever]

### Rules

You can store in filters rules whatever conditions you like in plain ruby and the string will be evaulated. Inside the rules, object have to be called as instance variables. These instance variables indeed need to be present and can be declared in a few ways.

1. The model name of the instance you called `skim` from, like the user, will be defined automatically based on model name, so if you call `user.skim rooms_collection` you will have `@user` variable defined.
2. Based on the skimmed collection, instance variables are defined. In the case above, `@room` variable will be present for each of the rooms to be evaluated in. The collection name is calculated based on the class of the first object in the collection and will raise an error if is not the same for all collection elements. You can override this calculation specifying the `object_name` of the collection (the skimming will look for collection_filters with that `object_name`)
3. You can pass as third argument an hash of objects like this `user.skim rooms_collection, time: Time.zone.now, whatever: @you_want` and you will have `@time` and `@whatever` variables defined for rule evaluation.

WARNING: since the strings get evaluated, i recommend not to allow anyone except project developers to create collection_filters, in order to prevent malicious code from being executed.
