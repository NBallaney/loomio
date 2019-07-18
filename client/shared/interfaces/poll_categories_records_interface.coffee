BaseRecordsInterface = require 'shared/record_store/base_records_interface'
PollCategoriesModel  = require 'shared/models/poll_categories_model'

module.exports = class PollCategoriesRecordsInterface extends BaseRecordsInterface
  model: PollCategoriesModel

  fetch: () ->
    @remote.get ""

  fetchById: (category_id) ->
    @remote.get(category_id)