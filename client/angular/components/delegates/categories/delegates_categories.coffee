Records        = require 'shared/services/records'
{ applyLoadingFunction } = require 'shared/helpers/apply'
Session       = require 'shared/services/session'

angular.module('loomioApp').directive 'delegatesCategories', ->
  scope: {user: '='}
  templateUrl: 'generated/components/delegates/categories/delegates_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.user = Session.user()
    $scope.user.memberr = []
    $scope.user.memberr_ids = []
    getCookie =(cname) ->
      name = cname + '='
      decodedCookie = decodeURIComponent(document.cookie)
      ca = decodedCookie.split(';')
      i = 0
      while i < ca.length
        c = ca[i]
        while c.charAt(0) == ' '
          c = c.substring(1)
        if c.indexOf(name) == 0
          return c.substring(name.length, c.length)
        i++
      ''

    $scope.getCategory = (category) ->
      Records.delegates.fetchDelegates($scope.user.id,category.categoryId).then (members) ->
        # console.log('member  are')
        # console.log(members)
        $scope.user.memberr = []
        $scope.user.memberr_ids = []
        if members.status == 200
          # console.log("hello")
          angular.forEach  members.delegates, (value, key) ->
            # console.log(value)
            if $scope.user.memberr_ids.indexOf(value.id) < 0
              $scope.user.memberr.push(value)
              $scope.user.memberr_ids.push(value.id)
      # console.log($scope.user)
      $scope.user.categoryId = category.categoryId
    
    $scope.fetchRecords = ->
      Records.groups.getGroupCategories(getCookie('groupId'))

    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      $scope.pollCategories = res.poll_categories
    )
]