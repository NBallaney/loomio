Records        = require 'shared/services/records'
Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
LmoUrlService  = require 'shared/services/lmo_url_service'
FlashService   = require 'shared/services/flash_service'

{ listenForTranslations, listenForReactions } = require 'shared/helpers/listen'

angular.module('loomioApp').directive 'pollCommonDetailsPanel', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/details_panel/poll_common_details_panel.html'
  controller: ['$scope', 'clipboard', ($scope, clipboard) ->
    $scope.actions = [
      name: 'translate_poll'
      icon: 'mdi-translate'
      canPerform: -> AbilityService.canTranslate($scope.poll)
      perform:    -> $scope.poll.translate(Session.user().locale)
    ,
      name: 'announce_poll'
      icon: 'mdi-account-plus'
      canPerform: -> AbilityService.canAdministerPoll($scope.poll) and $scope.poll.isActive()
      perform:    -> ModalService.open 'AnnouncementModal', announcement: ->
        Records.announcements.buildFromModel($scope.poll)
    ,
    #   name: 'add_resource'
    #   icon: 'mdi-attachment'
    #   canPerform: -> AbilityService.canAdministerPoll($scope.poll)
    #   perform:    -> ModalService.open 'DocumentModal', doc: ->
    #     Records.documents.build
    #       modelId:   $scope.poll.id
    #       modelType: 'Poll'
    # ,
    #   name: 'copy_url'
    #   icon: 'mdi-link'
    #   canPerform: -> clipboard.supported
    #   perform:    ->
    #     clipboard.copyText(LmoUrlService.poll($scope.poll, {}, absolute: true))
    #     FlashService.success("action_dock.poll_copied")
    # ,
      name: 'show_history'
      icon: 'mdi-history'
      canPerform: -> $scope.poll.edited()
      perform:    -> ModalService.open 'RevisionHistoryModal', model: -> $scope.poll
    ]
    $scope.groupArray = []
    $scope.memberArray = []

    Records.groups.fetch().then((res) ->
      data = []
      for group in res.groups
        $scope.groupArray[group.id]=group.full_name
    )

    Records.groups.fetchChildGroups($scope.poll.groupId).then (members) ->
      if members.status == 200
        for member in members.members
          $scope.memberArray[member.id]=member.name
      else
        console.log "error"
    

    $scope.categoryDetails = ->
      "Category : #{$scope.poll.pollCategoryName}"

    $scope.getGroupDetail = ->
      if $scope.poll.pollCategoryName == "Alliance Decision"
        "Parent Group: #{ $scope.groupArray[$scope.poll.allianceParentId] }"
      else if $scope.poll.pollCategoryName == "Forge Alliance"
        if $scope.poll.additionalData
          "Child Group: #{ $scope.groupArray[$scope.poll.additionalData.group_id] }"
      else if $scope.poll.pollCategoryName == "Increase Voting Power" || $scope.poll.pollCategoryName == "Decrease Voting Power"
        if $scope.poll.additionalData
          if $scope.poll.additionalData.member_type=="member"
            "Member: #{$scope.memberArray[$scope.poll.additionalData.member_id]} <br/><br/>Vote Power: #{$scope.poll.additionalData.vote_power}"
          else
            "Group: #{$scope.groupArray[$scope.poll.additionalData.group_id]} <br/><br/>Vote Power: #{$scope.poll.additionalData.vote_power}"
      else if $scope.poll.pollCategoryName == "Exile Member"
        if $scope.poll.additionalData
          if $scope.poll.additionalData.member_type=="member"
            "Member: #{$scope.memberArray[$scope.poll.additionalData.user_id]}"
          else
            "Group: #{$scope.groupArray[$scope.poll.additionalData.group_id]}"
      else
        ""

    $scope.resubmissionDetails = (index, parentName) ->
      "#{$scope.getCategoryNumber(parseInt(index))} Submission : #{parentName}"

    $scope.getCategoryNumber = (number) ->
      if number == 0
        "First"
      else if number == 1
        "Second"
      else 
        "Third"

    $scope.showResubmission = -> $scope.poll.isProposal() && $scope.poll.resubmissionCount > 0

    if !$scope.poll.isProposal()
      $scope.actions.push
        name: 'edit_poll'
        icon: 'mdi-pencil'
        canPerform: -> AbilityService.canEditPoll($scope.poll)
        perform:    -> ModalService.open 'PollCommonEditModal', poll: -> $scope.poll

    listenForTranslations($scope)
    listenForReactions($scope, $scope.poll)
  ]
