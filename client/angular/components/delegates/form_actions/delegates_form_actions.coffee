{ submitForm }    = require 'shared/helpers/form'
{ submitOnEnter } = require 'shared/helpers/keyboard'

angular.module('loomioApp').directive 'delegatesFormActions', ->
  scope: {delegates: '='}
  replace: true
  templateUrl: 'generated/components/delegates/form_actions/delegates_form_actions.html'
  controller: ['$scope', ($scope) ->
    $scope.submit = submitForm $scope, $scope.delegates,
      successCallback: (data) ->
        $scope.delegates.membershipsCount = data.memberships.length
        $scope.$emit '$close'
      flashSuccess: 'delegates.flash.success'
      flashOptions: ->
        count: $scope.delegates.membershipsCount
    submitOnEnter($scope, anyInput: true)
  ]
