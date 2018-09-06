BaseModel = require 'shared/record_store/base_model'
AppConfig = require 'shared/services/app_config'

module.exports = class PollCategoriesModel extends BaseModel
  @singular: 'pollCategory'
  @plural: 'pollCategories'
  @uniqueIndices: ['id']
  @serializableAttributes: AppConfig.permittedParams.draft
