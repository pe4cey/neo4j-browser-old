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

'use strict';

angular.module('neo4jApp.directives')
  .directive 'resize', ['$document', ($document) ->
    link: (scope, element, attrs) ->

      element.on 'mousedown', (event) ->
        event.preventDefault()
        $document.on('mousemove', mousemove)
        $document.on('mouseup', mouseup)

      mousemove = (event) ->
        container = $(element).closest(attrs.resizeContainer)
        containerWidth = container.width()

        widthX = (containerWidth + container.offset().left) - event.pageX
        maxSize =  containerWidth * 0.95
        minSize =  100

        if (widthX > maxSize) then widthX = maxSize
        if (widthX < minSize) then widthX = minSize

        offset = 10

        resizeThis = $(element).siblings(attrs.resizeElement)

        resizeThis.css(
          width: (widthX + offset) + 'px'
        )

        element.css(
          right: widthX + 'px'
        )

      mouseup = () ->
        $document.unbind('mousemove', mousemove)
        $document.unbind('mouseup', mouseup)

  ]