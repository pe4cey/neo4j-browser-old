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

describe 'Controller: InspectorEditorCtrl', () ->

  beforeEach module 'neo4jApp.services', 'neo4jApp.controllers'

  beforeEach ->
    inject ($controller, $rootScope, GraphStyle, Collection, $timeout, Editor, CypherBuilder) ->
      @scope = $rootScope.$new()
      @editor = Editor

      $controller('InspectorEditorCtrl',
      {
        '$scope' : @scope
        GraphStyle: GraphStyle
        Collection: Collection
        $timeout: $timeout
        Editor: @editor
        CypherBuilder: CypherBuilder
      })

      @scope.$digest()

  it('should capture event', ->
    spyOn(@scope, '$broadcast').and.callThrough()
    @scope.$broadcast('updateInspector')
    expect(@scope.$broadcast).toHaveBeenCalledWith('updateInspector')
  )

  it('should be toggle edit mode when calling clickEdit', ->
    @scope.$broadcast('updateInspector')
    expect(@scope.editing).toBe no

    @scope.clickEdit()
    expect(@scope.editing).toBe yes

    @scope.clickEdit()
    expect(@scope.editing).toBe no
  )

  it('should set current item when event with data is triggered', ->
    data = {test:"test"}
    @scope.$broadcast('updateInspector', data)
    expect(@scope.currentItem).toEqual data
  )

  it('should not set current item when event with no data is triggered', ->
    @scope.$broadcast('updateInspector')
    expect(@scope.currentItem).toBeNull()
  )

#  it('should set inspector visibility to true when data is present', ->
#    item = {test:"test"}
#    anotherItem = {test:"test2"}
#
#    @scope.$broadcast('updateInspector', item)
#    expect(@scope.visible).toBe yes
#
#    @scope.$broadcast('updateInspector', anotherItem)
#    expect(@scope.visible).toBe yes
#
#    @scope.$broadcast('updateInspector')
#    expect(@scope.visible).toBe no
#  )

  describe('adding new properties', ->
    it('should add new item to newPropertyList', ->
      @scope.$broadcast('updateInspector')
      expect(@scope.newPropertyList.length).toBe
      @scope.addProperty()

      placeHolderProperty =
        _id: "1"
        key: ""
        value: ""

#      expect(@scope.adding).toBe yes
      expect(@scope.newPropertyList.length).toBe 1
      expect(@scope.newPropertyList[0]).toEqual placeHolderProperty
    )

    it('should allow no duplicate property keys', ->
      duplicateKey = "dupe"
      item =
        data:
          propertyList:
            [
              {
                _id: ""
                key: duplicateKey
                value: "anyvalue"
              }
            ]

      newProperty =
        _id: "1"
        key: "x"
        value: ""

      @scope.$broadcast('updateInspector', item)
      @scope.addProperty()
      expect(@scope.validPair newProperty).toBe yes

      newProperty.key = duplicateKey
      expect(@scope.validPair newProperty).toBe no
    )


    it('should not allow empty key in properties', ->
      property = {
        _id: "1"
        key: ""
        value: "anyvalue"
      }
      item =
        data:
          propertyList:
            []

      @scope.$broadcast('updateInspector', item)
      @scope.addProperty()
      expect(@scope.validPair property).toBe no
    )


    it('should save properties that are valid', ->
      item =
        data:
          propertyList:
            [
              {
                _id: "1"
                key: "key1"
                value: "anyvalue"
              }
            ]

      newProperty =
        _id: "w"
        key: "key2"
        value: "value"

      @scope.$broadcast('updateInspector', item)

      #replace validPair function
      @scope.validPair = -> yes

      @scope.addProperty()
      expect(@scope.currentItem.data.propertyList.length).toBe 1
      expect(@scope.newPropertyList.length).toBe 1

      @scope.savePair newProperty
      expect(@scope.currentItem.data.propertyList.length).toBe 2
      expect(@scope.newPropertyList.length).toBe 1
    )

    it('should not save properties that are not valid', ->
      item =
        data:
          propertyList:
            [
              {
                _id: "1"
                key: "key1"
                value: "anyvalue"
              }
            ]
      newProperty =
        _id: "w"
        key: "key2"
        value: "value"

      @scope.$broadcast('updateInspector', item)

      #replace validPair function
      @scope.validPair = -> no

      @scope.addProperty()
      expect(@scope.currentItem.data.propertyList.length).toBe 1
      expect(@scope.newPropertyList.length).toBe 1
      expect(@scope.newPropertyList[0]).toEqual item

      @scope.savePair newProperty
      expect(@scope.currentItem.data.propertyList.length).toBe 1
      expect(@scope.newPropertyList.length).toBe 1
      expect(@scope.newPropertyList[0]).toEqual newProperty
    )

    it('should add properties that have been change do the cypher builder', ->
      x = {
        _id: "1"
        key: "key1"
        value: "anyvalue"
      }

      item =
        data:
          propertyList:
            [
              {
                _id: "1"
                key: "key1"
                value: "anyvalue"
              },
              {
                _id: "2"
                key: "key2"
                value: "anyvalue2"
              }
            ]
          propertyMap:
            "key1": "anyvalue"
            "key2": "anyvalue2"

      spyOn(@editor, "setContent")
      @scope.$broadcast('updateInspector', item)

      expect(@scope.currentItem.data.propertyList[0]).toEqual x

      @scope.updateEditor()
      expect(@editor.setContent).toHaveBeenCalledWith("")

      expect(@scope.currentItem.data.propertyList[0].value).toBe
      @scope.currentItem.data.propertyList[0].value = "newvalue"

      @scope.updateEditor()

      mostRecentArgsSentToEditorSetContent = @editor.setContent.calls.mostRecent().args[0]
      expect(mostRecentArgsSentToEditorSetContent).toContain("newvalue")
      expect(mostRecentArgsSentToEditorSetContent).not.toContain("anyvalue")
      expect(mostRecentArgsSentToEditorSetContent).not.toContain("anyvalue2")
    )

    it('should revert to original data item', ->
      item =
        data:
          propertyList:
            [
              {
                _id: "1"
                key: "key1"
                value: "anyvalue"
              }
            ]
      @scope.$broadcast('updateInspector', item)
      expect(@scope.currentItem).toEqual item

      @scope.currentItem = {useless: "object"}
      expect(@scope.currentItem).not.toEqual item

      @scope.clickCancel()

      expect(@scope.editing).toBe no
      expect(@scope.currentItem).toEqual item
    )

    it('should delete property key from data item', ->
      property = {
        _id: "1"
        key: "key1"
        value: "anyvalue"
      }
      item =
        data:
          propertyList:
            [
              property
            ]
      @scope.$broadcast('updateInspector', item)
      expect(@scope.currentItem.data.propertyList.length).toBe 1

      @scope.deletePair(property)
      expect(@scope.currentItem.data.propertyList.length).toBe 0
    )
  )
