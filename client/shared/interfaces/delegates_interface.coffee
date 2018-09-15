BaseRecordsInterface = require 'shared/record_store/base_records_interface'
DelegatesModel  = require 'shared/models/delegates_model'

module.exports = class DelegatesInterface extends BaseRecordsInterface
  model: DelegatesModel

  apiEndPoint: "users" 
  
  fetchUsers: () ->
    @remote.get ""

  buildFromModel: (model) ->
    @build
      model: model

  findOrFetchById: (id, action) ->
    record = @find(id)
    if record && (!ensureComplete || record.complete)
      Promise.resolve(record)
    else
      @remote.getMember(id, action).then => @find(id)

  findOrFetchByIds: (id) ->
    @remote.get id + "/fetch_delegates"

  fetchByUser: (user, options = {}) ->
    @fetch
      path: user.id + '/fetch_delegates'
      params: options

  assignDelegates: (id, categoryId, delegateIds) =>
    @remote.postMember(id, "assign_delegates", {
      id: id,
      poll_category_id: categoryId
      delegate_ids: delegateIds
    })