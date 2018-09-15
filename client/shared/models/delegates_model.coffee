BaseModel = require 'shared/record_store/base_model'
AppConfig = require 'shared/services/app_config'

module.exports = class DelegatesModel extends BaseModel
  @singular: 'delegate'
  @plural: 'delegates'
  @serializableAttributes: AppConfig.permittedParams.delegate_user

  defaultValues: ->
    delegates: []

  relationships: ->
    @belongsTo 'user'

  userEmail: ->
    @user().email