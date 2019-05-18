Records        = require 'shared/services/records'
Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
EventBus       = require 'shared/services/event_bus'
utils          = require 'shared/record_store/utils'
{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'pollCommonModifyConsensusThresholds', ->
#   scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/modify_consensus_thresholds/poll_common_modify_consensus_thresholds.html'
  controller: ['$scope', ($scope) ->
    $scope.poll = $scope.$parent.poll
    $scope.excluded_keys = ["id","name","created_at","updated_at","$$hashKey"]
    $scope.category_array = []
    $scope.category_selected = false
#     $scope.attribute_list = []
#     $scope.selected_attr = ""
#     $scope.selected_value = ""
    $scope.poll.additionalData.active_days = ""
    $scope.poll.additionalData.pass_percentage = ""
    $scope.poll.additionalData.stop_percentage =  ""
    $scope.poll.additionalData.pass_percentage_drop =  ""
    $scope.poll.additionalData.resubmission_active_days =  ""
    if $scope.poll.additionalData.apd_data1
      $scope.selectablegroupid = $scope.poll.main_group_id
    else
      $scope.selectablegroupid = $scope.poll.groupId

#     $scope.current_category_attribute = {};
    Records.groups.fetchCategoryAttributes($scope.selectablegroupid).then (attributes) ->
      $scope.category_attributes = attributes.poll_categories
      angular.forEach $scope.category_attributes , (value,index) ->
            $scope.category_array.push(value.id)

      $scope.selectCategory = (category) ->
            $scope.current_category_attribute = $scope.category_attributes[$scope.category_array.indexOf(category)]
            $scope.category_selected = true
            # $scope.attribute_list = []
            angular.forEach $scope.current_category_attribute, (value,index) -> 
                  if $scope.excluded_keys.indexOf(index) < 0
                       $scope.poll.additionalData[index] = value 
                  # console.log $scope.poll.additionalData
            
      
      # $scope.select_attribute = (attribute) ->
      #       $scope.selected_attr = attribute
      #       $scope.selected_value = $scope.current_category_attribute[attribute]
      #       angular.forEach $scope.current_category_attribute, (value,index) -> 
      #             if $scope.excluded_keys.indexOf(index) < 0
      #                   $scope.poll.additionalData[index] = value
      #       $scope.poll.additionalData[attribute] = $scope.selected_value

      # $scope.change_attr_value = (attrval) ->
      #       $scope.poll.additionalData[$scope.selected_attr] = parseInt(attrval)
  ]