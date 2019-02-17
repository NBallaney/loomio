BaseRecordsInterface = require 'shared/record_store/base_records_interface'
DelegatesModel  = require 'shared/models/delegates_model'

module.exports = class DelegatesInterface extends BaseRecordsInterface
  model: DelegatesModel

  apiEndPoint: "users" 
  
  fetchUsers: () ->
    @remote.get ""

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

  fetchDelegates: (user,category) ->
    @remote.get "#{user}/fetch_delegates?poll_category_id=#{category}"