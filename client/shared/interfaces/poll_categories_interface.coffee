BaseRecordsInterface = require 'shared/record_store/base_records_interface'
PollCategoriesModel  = require 'shared/models/poll_categories_model'

module.exports = class PollCategoriesInterface extends BaseRecordsInterface
  model: PollCategoriesModel

  fetch: () ->
    @remote.get ""