BaseRecordsInterface = require 'shared/record_store/base_records_interface'
PollCategoriesModel  = require 'shared/models/poll_groups_model'

module.exports = class PollGroupsInterface extends BaseRecordsInterface
  model: PollGroupsModel

  fetch: () ->
    @remote.get ""