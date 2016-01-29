###!
Copyright (c) 2002-2015 "Neo Technology,"
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

do ->
  noop = ->

  numberOfItemsInContextMenu = 3

  arc = (radius, itemNumber, width = 30) ->
    itemNumber = itemNumber-1
    startAngle = ((2*Math.PI)/numberOfItemsInContextMenu) * itemNumber
    endAngle = startAngle + ((2*Math.PI)/numberOfItemsInContextMenu)
    innerRadius = Math.max(radius + 8, 20)
    d3.svg.arc().innerRadius(innerRadius).outerRadius(innerRadius + width).startAngle(startAngle).endAngle(endAngle)

  startArc = (node, itemNumber) -> arc(node.radius, itemNumber, 1)()

  getSelectedNode = (node) -> if node.selected then [node] else []

  attachContextEvent = (event, elems, viz, content, label) ->
    for elem in elems
      elem.on('mousedown.drag', ->
        d3.event.stopPropagation()
        null)
      elem.on('mouseup', (node) ->
        viz.trigger(event, node))
      elem.on('mouseover', (node) ->
        node.contextMenu =
          menuSelection: event
          menuContent: content
          label:label
        viz.trigger('menuMouseOver', node))
      elem.on('mouseout', (node) ->
        delete node.contextMenu
        viz.trigger('menuMouseOut', node))

  donutRemoveNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      itemNumber = 1
      path = selection.selectAll('path.remove_node').data(getSelectedNode)

      tab = path.enter()
      .append('path')
      .classed('remove_node', true)
      .classed('context-menu-item', true)
      .attr
          d: (node) -> arc(node.radius, itemNumber, 1)()

      text = path.enter()
      .append('text')
      .classed('context-menu-item', true)
      .text('\uf00d')
      .attr("transform", "scale(0.1)")
      .attr
          'font-family': 'FontAwesome'
          fill: (node) -> viz.style.forNode(node).get('text-color-internal')
          x: (node) -> arc(node.radius, itemNumber).centroid()[0]  - 4
          y: (node) -> arc(node.radius, itemNumber).centroid()[1]

      attachContextEvent('nodeClose', [tab, text], viz, "Remove node from the visualization", "\uf00d")

      tab
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber)()

      text
      .transition()
      .duration(200)
      .attr("transform", "scale(1)")

      path
      .exit()
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber, 1)()
      .remove()

    onTick: noop

  )

  donutExpandNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      itemNumber = 2
      path = selection.selectAll('path.expand_node').data((node) -> if not node.expanded and node.selected then [node] else [])

      tab = path.enter()
      .append("path")
      .classed('expand_node', true)
      .classed('context-menu-item', true)
      .attr
          d: (node) -> startArc(node, itemNumber)

      text = path.enter()
      .append('text')
      .classed('context-menu-item', true)
      .text('\uf0b2')
      .attr("transform", "scale(0.1)")
      .attr
          'font-family': 'FontAwesome'
          fill: (node) -> viz.style.forNode(node).get('text-color-internal')
          x: (node) -> arc(node.radius, itemNumber).centroid()[0]
          y: (node) -> arc(node.radius, itemNumber).centroid()[1] + 4

      attachContextEvent('nodeExpand', [tab, text], viz, "Expand child relationships", "\uf0b2")

      tab
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber)()

      text
      .transition()
      .duration(200)
      .attr("transform", "scale(1)")

      path
      .exit()
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber, 1)()
      .remove()
    onTick: noop
  )

  donutUnlockNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      itemNumber = 3
      path = selection.selectAll('path.unlock_node').data(getSelectedNode)

      tab = path.enter()
      .append("path")
      .classed('unlock_node', true)
      .classed('context-menu-item', true)
      .attr
          d: (node) -> startArc(node, itemNumber)

      text = path.enter()
      .append('text')
      .classed('context-menu-item', true)
      .text('\uf09c')
      .attr("transform", "scale(0.1)")
      .attr
          'font-family': 'FontAwesome'
          fill: (node) -> viz.style.forNode(node).get('text-color-internal')
          x: (node) -> arc(node.radius, itemNumber).centroid()[0] + 4
          y: (node) -> arc(node.radius, itemNumber).centroid()[1]

      attachContextEvent('nodeUnlock', [tab], viz, "Unlock the node to relayout the graph", "\uf09c")

      tab
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber)()

      text
      .transition()
      .duration(200)
      .attr("transform", "scale(1)")

      path
      .exit()
      .transition()
      .duration(200)
      .attr
          d: (node) -> arc(node.radius, itemNumber, 1)()
      .remove()

    onTick: noop
  )

  neo.renderers.menu.push(donutExpandNode)
  neo.renderers.menu.push(donutRemoveNode)
  neo.renderers.menu.push(donutUnlockNode)
