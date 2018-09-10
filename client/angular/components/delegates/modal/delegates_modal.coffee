angular.module('loomioApp').factory 'DelegatesModal', ->
  templateUrl: 'generated/components/delegates/modal/delegates_modal.html'
  controller: ['$scope', 'delegates', ($scope, delegates) ->
    $scope.delegates = delegates
  ]
