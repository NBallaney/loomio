BaseRecordsInterface = require 'shared/record_store/base_records_interface'
GroupModel           = require 'shared/models/group_model'

module.exports = class GroupRecordsInterface extends BaseRecordsInterface
  model: GroupModel

  fetch: () ->
    @remote.get ""

  fuzzyFind: (id) ->
    # could be id or key or handle
    @find(id) || _.first(@find(handle: id))

  findOrFetch: (id, options = {}, ensureComplete = false) ->
    record = @fuzzyFind(id)
    if record && (!ensureComplete || record.complete)
      Promise.resolve(record)
    else
      @remote.fetchById(id, options).then => @fuzzyFind(id)

  fetchByParent: (parentGroup) ->
    @fetch
      path: "#{parentGroup.id}/subgroups"
  
  fetchChildGroups: (groupId) ->
    @remote.get(groupId+'/group_members.json',{})

  fetchExploreGroups: (query, options = {}) ->
    options['q'] = query
    @fetch
      params: options

  getExploreResultsCount: (query, options = {}) ->
    options['q'] = query
    @fetch
      path: 'count_explore_results'
      params: options

  
  getGroupCategories: (group) ->
    console.log(group)
    @remote.get group+".json"

  getInvitableGroups: (group) ->
    @remote.get "#{group}/invitable_groups.json"

