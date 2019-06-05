
svg = require 'svg.js'

AppConfig = require 'shared/services/app_config'

angular.module('loomioApp').directive 'pollProposalChart', ->
  template: '<div class="poll-proposal-chart"></div>'
  replace: true
  scope:
    stanceCounts: '='
    diameter: '@'
  restrict: 'E'
  controller: ['$scope', '$element', ($scope, $element) ->
    draw = svg($element[0]).size('100%', '100%')
    half = $scope.diameter / 2.0
    radius = half
    shapes = []
    $scope.executedd = 0
    arcPath = (startAngle, endAngle) ->
      rad = Math.PI / 180
      x1 = half + radius * Math.cos(-startAngle * rad)
      x2 = half + radius * Math.cos(-endAngle * rad)
      y1 = half + radius * Math.sin(-startAngle * rad)
      y2 = half + radius * Math.sin(-endAngle * rad)
      ["M", half, half, "L", x1, y1, "A", radius, radius, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"].join(' ')
    if !$scope.executedd
      $scope.countstance = $scope.stanceCounts
      # console.log $scope.countstance
      $scope.executedd=1

    uniquePositionsCount = ->
      _.compact($scope.countstance).length

    $scope.$watchCollection 'countstance', ->
      _.each shapes, (shape) -> shape.remove()
      start = 90
      
      switch uniquePositionsCount()
        when 0
          
          shapes.push draw.circle($scope.diameter).attr
            'stroke-width': 0
            fill: '#aaa'
        when 1
          # console.log "hii"
          shapes.push draw.circle($scope.diameter).attr
            'stroke-width': 0
            fill: AppConfig.pollColors.proposal[_.findIndex($scope.countstance, (count) -> count > 0)]
        else
          # console.log $scope.stanceCounts
          # console.log "hello"
          _.each $scope.countstance, (count, index) ->
            # console.log "count is "+count
            return unless count > 0
            angle = 360/_.sum($scope.countstance)*count
            shapes.push draw.path(arcPath(start, start + angle)).attr
              'stroke-width': 0
              fill: AppConfig.pollColors.proposal[index]
            start += angle
        
  ]
