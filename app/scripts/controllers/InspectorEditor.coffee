###!
Copyright (c) 2002-2016 "Neo Technology,"
Network Engine for Objects in Lund AB [http://neotechnology.com]

This file is part of Neo4j.

Neo4j is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorEditorCtrl', [
    '$scope'
    'GraphStyle'
    'Collection'
    '$timeout'
    'Editor'
    'CypherBuilder'
    ($scope, graphStyle, Collection, $timeout, Editor, CypherBuilder) ->
      $scope.visible = no

      $scope.$on 'updateInspector', ($event, data) ->
        originalItem = angular.copy(data)

        $scope.selectedItem = ->
          $scope.currentItem

        $scope.toggle = ->
          $scope.visible = !$scope.visible

        $scope.close = ->
          $scope.visible = no

        $scope.open = ->
          $scope.visible = yes

        $scope.errorMessage = null
        $scope.editing = no
        $scope.newPropertyList = []

        if data
          $scope.currentItem = angular.copy(originalItem)
        else
          $scope.currentItem = null

        $scope.sizes = graphStyle.defaultSizes()
        $scope.colors = graphStyle.defaultColors()
        $scope.editor = Editor

        $scope.clickCancel = () ->
          $scope.editing = no
          $scope.currentItem = angular.copy(originalItem)

        $scope.addProperty = ->
          newProperty =
            _id: ($scope.newPropertyList.length + 1).toString()
            key: ""
            value: ""
          $scope.newPropertyList.push newProperty


        $scope.clickEdit = () ->
          $scope.addProperty()
          $scope.editing = !$scope.editing

        $scope.validPair = (property) ->
          unless property.key
            $scope.errorMessage = null
            return no

          for properties in $scope.currentItem.data.propertyList
            if property.key is properties.key
              $scope.errorMessage = "Non unique property key"
              return no
          yes

        $scope.savePair = (property) ->
          if $scope.validPair property
            delete property._id

            $scope.currentItem.data.propertyList.push property
            $scope.newPropertyList = []

            $scope.addProperty()

        $scope.clickDeleteItem = ->
          cypherBuilder = new CypherBuilder("n")
          cypherBuilder.comment "Editor generated query"

          if ($scope.currentItem.data.isNode)
            cypherBuilder.matchNodeById $scope.currentItem.data.id
            cypherBuilder.removeNode()
          if ($scope.currentItem.data.isRelationship)
            cypherBuilder.matchRelationshipById $scope.currentItem.data.id
            cypherBuilder.removeRealtionship()

          Editor.setContent(cypherBuilder.buildUpdateQuery())

        $scope.deletePair = (property) ->
          $scope.currentItem.data.propertyList.splice($scope.currentItem.data.propertyList.indexOf(property), 1)

        $scope.updateEditor = ->
          cypherBuilder = new CypherBuilder("n")
          cypherBuilder.comment "Editor generated query"
          if ($scope.currentItem.data.isNode) then cypherBuilder.matchNodeById $scope.currentItem.data.id
          if ($scope.currentItem.data.isRelationship) then cypherBuilder.matchRelationshipById $scope.currentItem.data.id

          originalKeys = originalItem.data.propertyList.map (p) -> p.key
          currentKeys = $scope.currentItem.data.propertyList.map (p) -> p.key

          for key in originalKeys.filter((x) -> currentKeys.indexOf(x) < 0)
            cypherBuilder.removeProperty key

          for properties in $scope.currentItem.data.propertyList
            unless originalItem.data.propertyMap[properties.key] is properties.value
              cypherBuilder.set properties.key, properties.value

          cypherBuilder.returnAll()
          Editor.setContent(cypherBuilder.buildUpdateQuery())

        $scope.styleForItem = (item) ->
          style = graphStyle.forEntity(item)
          {
            'background-color': style.props.color
            'color': style.props['text-color-internal']
          }

        $scope.styleForLabel = (label) ->
          item =
            labels: [label]
            isNode: true
          $scope.styleForItem(item)
  ]
