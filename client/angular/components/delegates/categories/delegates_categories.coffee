Records        = require 'shared/services/records'
{ applyLoadingFunction } = require 'shared/helpers/apply'
Session       = require 'shared/services/session'

angular.module('loomioApp').directive 'delegatesCategories', ->
  # scope: {group: '='}
  templateUrl: 'generated/components/delegates/categories/delegates_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.user = Session.user()
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
    $scope.fetchRecords = ->
      Records.groups.getGroupCategories(getCookie('groupId'))

    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      $scope.pollCategories = res.poll_categories
    )
]