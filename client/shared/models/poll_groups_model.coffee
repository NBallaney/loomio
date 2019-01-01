BaseModel = require 'shared/record_store/base_model'
AppConfig = require 'shared/services/app_config'

module.exports = class PollGroupsModel extends BaseModel
  @singular: 'pollGroup'
  @plural: 'pollGroups'
  @uniqueIndices: ['id']
  @serializableAttributes: AppConfig.permittedParams.draft