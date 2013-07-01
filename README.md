Earlydoc Authorization
======================

### Usage

Active Model
============

Include the authentication concern in your model.

    require 'earlydoc_auth'

    class MyModel
      include MongoMapper::Document
      include ActiveModel::Authenticates
    end

Action Pack (controller)
============

Include the authentication concerns in your controller(s).

    class ApplicationController < ActionController::Base
      include ActionPack::EarlydocAuth::Authentication
      include ActionPack::EarlydocAuth::Cookies
    end

To support progressive registration flows, the controller gains a `current_authenticated_id(model)` method that returns an object's id or alternatively the session id if no authenticated object is available:

    session_or_user_id  = current_authenticated_id(User)


##### Tests

Run the gem test suite with `rake test`. Note, the dependency on MongoMapper means that a `test` database may be created on 127.0.0.1:27017 when testing persistent logic.