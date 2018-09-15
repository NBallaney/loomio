angular.module('loomioApp').directive 'delegatesCard', ->
  scope: {userPage: '='}
  templateUrl: 'generated/components/delegates/card/delegates_card.html'
  controller: ['$scope', ($scope, model) ->
    $scope.manageDelegates = -> $scope.$parent.userPage.openDelegatesModal()
  ]
