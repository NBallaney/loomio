Records        = require 'shared/services/records'
Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
LmoUrlService  = require 'shared/services/lmo_url_service'
FlashService   = require 'shared/services/flash_service'
{ applyLoadingFunction } = require 'shared/helpers/apply'

{ listenForTranslations, listenForReactions } = require 'shared/helpers/listen'

angular.module('loomioApp').directive 'pollCommonAllianceParentDecision', ->
  templateUrl: 'generated/components/poll/common/alliance_parent_decision/poll_common_alliance_parent_decision.html'
  controller: ['$scope', 'clipboard', ($scope, clipboard) ->
    
    $scope.poll = $scope.$parent.$parent.poll
    $scope.parentAllianceGroupData = []
    $scope.secondParentGroupData = []
    $scope.categroyDropDown = []
    $scope.secondCategoryDropDown = []
    $scope.categoryArray = []
    $scope.firstcategory = false
    $scope.scecondcategory = false
    $scope.secondgroup = false
    $scope.firstgroup = false
    $scope.category_array = []
    $scope.finalselectedcategory = ''
    $scope.finalcategory = ''
    $scope.finalcategoryid = ''
    $scope.poll.main_group_id = ''

    Records.groups.fetchChildGroups($scope.poll.groupId).then((res) ->          
      for parentgroup in res.parent_groups
        $scope.parentAllianceGroupData.push {"id":parentgroup.id,"name":parentgroup.full_name}            
    )

    $scope.fetchRecords = ->
        $scope.retain_fields = ['apd_data1','apd_data2']
        $scope.firstcategory = true
        $scope.categroyDropDown = []
        $scope.secondCategoryDropDown = [] 
        $scope.secondcategory = false
        $scope.category_array = []
        $scope.finalcategory = ''
        $scope.finalcategoryid = ''
        Records.groups.getGroupCategories($scope.poll.additionalData.apd_data1.group_id).then((res) ->                   
            angular.forEach res.poll_categories, (value, key) ->
                $scope.category_array[value.id] = value.name
                $scope.categroyDropDown.push(value)
        )
    
    $scope.fetchRecords1 = ->
        $scope.scecondcategory = true
        $scope.secondCategoryDropDown = []
        $scope.category_array2 = []
        $scope.finalcategory = ''
        $scope.finalcategoryid = ''
        Records.groups.getGroupCategories($scope.poll.additionalData.apd_data2.group_id).then((res) ->
            angular.forEach res.poll_categories, (value, key) ->
                if value.name != "Alliance Parent Decision"
                    $scope.category_array2[value.id] = value.name
                    $scope.secondCategoryDropDown.push(value)
        )

    $scope.getParentGroupData2 = ->
        $scope.finalcategory = ''
        $scope.finalcategoryid = ''
        $scope.secondParentGroupData = []
        if $scope.category_array[$scope.poll.additionalData.apd_data1.poll_category_id] =='Alliance Parent Decision'
            Records.groups.fetchChildGroups($scope.poll.additionalData.apd_data1.group_id).then((res) ->          
                for parentgroup in res.parent_groups
                    $scope.secondParentGroupData.push {"id":parentgroup.id,"name":parentgroup.full_name}            
                )
        else
            delete $scope.poll.additionalData.apd_data2
            $scope.finalcategory =  $scope.category_array[$scope.poll.additionalData.apd_data1.poll_category_id]
            $scope.finalcategoryid = $scope.poll.additionalData.apd_data1.poll_category_id
            $scope.poll.main_group_id = $scope.poll.additionalData.apd_data1.group_id

    $scope.selectedcategory = (category) ->
        allowed_keys = ['apd_data1','apd_data2']
        angular.forEach $scope.poll.additionalData, (value,key) ->
            if allowed_keys.indexOf(key) < 0
                delete $scope.poll.additionalData[key]
        
        $scope.poll.main_group_id = $scope.poll.additionalData.apd_data2.group_id
        # if $scope.poll.additionalData.apd_data2
        #     $scope.poll.groupId = $scope.poll.additionalData.apd_data2.group_id
        # else
        #     if $scope.poll.additionalData.apd_data1
        #         $scope.poll.groupId = $scope.poll.additionalData.apd_data1.group_id

        
        $scope.finalcategory =  $scope.category_array2[$scope.poll.additionalData.apd_data2.poll_category_id]
        $scope.finalcategoryid = $scope.poll.additionalData.apd_data2.poll_category_id

        # console.log $scope.poll
    

  ]
