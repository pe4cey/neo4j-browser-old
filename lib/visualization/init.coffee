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

  contentMenuItems = 30
  nodeRingStrokeSize = 8
  contextMenuItemRadius= 8
  minimumContentConnection = 50

  menuItemX = (r, p) -> menuItemPosition(r, p).x
  menuItemY = (r, p) -> menuItemPosition(r, p).y

  menuItemPosition = (r, p) ->
    r = r + (nodeRingStrokeSize * 2)
    if r < minimumContentConnection then r = minimumContentConnection
    theta = (Math.PI*2) / contentMenuItems
    angle = theta * p

    x: r * Math.cos(angle)
    y: r * Math.sin(angle)

  getSelectedNode = (node) -> if node.selected and node.selected then [node] else []

  attachContextEvent = (event, elems, viz) ->
    for elem in elems
      elem.on('click', (node) ->
        viz.trigger(event, node))

  removeNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.remove_node').data(getSelectedNode)

      circle = circles.enter()
      .append('circle')
      .classed('remove_node', true)
      .classed('contextItem', true)
      .attr
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        cx: (node) -> menuItemX node.radius, 25
        cy: (node) -> menuItemY node.radius, 25
        r: contextMenuItemRadius
        fill: (node) -> viz.style.forNode(node).get('color')

      text = circles.enter()
      .append('text')
      .text('\uf00d')
      .attr
        'text-anchor': 'middle'
        'pointer-events': 'none'
        'font-family': 'FontAwesome'
        'font-size': '8px'
        fill: (node) -> viz.style.forNode(node).get('text-color-internal')
        x: (node) -> menuItemX node.radius, 25
        y: (node) -> (menuItemY node.radius, 25) + 2

#      text = circles.enter()
#      .append('text')
#      .text('Close')
#      .attr
#          'text-anchor': 'middle'
#          'pointer-events': 'none'
#          'font-size': '8px'
#          fill: (node) -> viz.style.forNode(node).get('text-color-internal')
#          x: (node) -> menuItemX node.radius + contextMenuItemRadius, 25
#          y: (node) -> (menuItemY node.radius + contextMenuItemRadius, 25) + 3


      attachContextEvent('nodeClose', [circle, text], viz)

      circles.exit().remove()
    onTick: noop
  )

  expandNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.expand_node').data(getSelectedNode)

      circle = circles.enter()
      .append('circle')
      .classed('expand_node', true)
      .classed('contextItem', true)
      .attr
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        cx: (node) -> menuItemX node.radius, 27
        cy: (node) -> menuItemY node.radius, 27
        r: contextMenuItemRadius
        fill: (node) -> viz.style.forNode(node).get('color')

      text = circles.enter()
      .append('text')
      .text('\uf067')
      .attr
        'text-anchor': 'middle'
        'pointer-events': 'none'
        'font-family': 'FontAwesome'
        'font-size': '8px'
        fill: (node) -> viz.style.forNode(node).get('text-color-internal')
        x: (node) -> menuItemX node.radius, 27
        y: (node) -> (menuItemY node.radius, 27) + 3

      attachContextEvent('nodeExpand', [circle, text], viz)

      circles.exit().remove()
    onTick: noop
  )

  unlockNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.unlock_node').data(getSelectedNode)

      circle = circles.enter()
      .append('circle')
      .classed('unlock_node', true)
      .classed('contextItem', true)
      .attr
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        cx: (node) -> menuItemX node.radius, 29
        cy: (node) -> menuItemY node.radius, 29
        r: contextMenuItemRadius
        fill: (node) -> viz.style.forNode(node).get('color')

      text = circles.enter()
      .append('text')
      .text('\uf09c')
      .attr
        'text-anchor': 'middle'
        'pointer-events': 'none'
        'font-family': 'FontAwesome'
        'font-size': '8px'
        fill: (node) -> viz.style.forNode(node).get('text-color-internal')
        x: (node) -> menuItemX node.radius, 29
        y: (node) -> (menuItemY node.radius, 29) + 2

      attachContextEvent('nodeUnlock', [circle, text], viz)

      circles.exit().remove()
    onTick: noop
  )
  
  editNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.edit_node').data(getSelectedNode)

      circle = circles.enter()
      .append('circle')
      .classed('edit_node', true)
      .classed('contextItem', true)
      .attr
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        cx: (node) -> menuItemX node.radius, 12
        cy: (node) -> menuItemY node.radius, 12
        r: contextMenuItemRadius
        fill: (node) -> viz.style.forNode(node).get('color')

      text = circles.enter()
      .append('text')
      .text('\uf040')
      .attr
        opacity: '0.5'
        'text-anchor': 'middle'
        'pointer-events': 'none'
        'font-family': 'FontAwesome'
        'font-size': '8px'
        fill: (node) -> viz.style.forNode(node).get('text-color-internal')
        x: (node) -> menuItemX node.radius, 12
        y: (node) -> (menuItemY node.radius, 12) + 2

      attachContextEvent('editNode', [circle, text], viz)

      circles.exit().remove()
    onTick: noop
  )

  deleteNode = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.delete_node').data(getSelectedNode)

      circle = circles.enter()
      .append('circle')
      .classed('delete_node', true)
      .classed('contextItem', true)
      .attr
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        cx: (node) -> menuItemX node.radius, 12
        cy: (node) -> menuItemY node.radius, 12
        r: contextMenuItemRadius
        fill: (node) -> viz.style.forNode(node).get('color')

      text = circles.enter()
      .append('text')
      .text('\uf014')
      .attr
        'text-anchor': 'middle'
        'pointer-events': 'none'
        'font-family': 'FontAwesome'
        'font-size': '8px'
        fill: (node) -> viz.style.forNode(node).get('text-color-internal')
        x: (node) -> menuItemX node.radius, 12
        y: (node) -> (menuItemY node.radius, 12) + 2


      attachContextEvent('deleteNode', [circle, text], viz)

      circles.exit().remove()
    onTick: noop
  )

  nodeOutline = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      circles = selection.selectAll('circle.outline').data((node) -> [node])

      circles.enter()
      .append('circle')
      .classed('outline', true)
      .attr
        cx: 0
        cy: 0

      circles
      .attr
        r: (node) -> node.radius
        fill: (node) -> viz.style.forNode(node).get('color')
        stroke: (node) -> viz.style.forNode(node).get('border-color')
        'stroke-width': (node) -> viz.style.forNode(node).get('border-width')

      circles.exit().remove()
    onTick: noop
  )

  nodeCaption = new neo.Renderer(
    onGraphChange: (selection, viz) ->
      text = selection.selectAll('text').data((node) -> node.caption)

      text.enter().append('text')
      .attr('text-anchor': 'middle')
      .attr('pointer-events': 'none')

      text
      .text((line) -> line.text)
      .attr('y', (line) -> line.baseline)
      .attr('font-size', (line) -> viz.style.forNode(line.node).get('font-size'))
      .attr('fill': (line) -> viz.style.forNode(line.node).get('text-color-internal'))

      text.exit().remove()

    onTick: noop
  )

  nodeRing = new neo.Renderer(
    onGraphChange: (selection) ->
      circles = selection.selectAll('circle.ring').data((node) -> [node])
      circles.enter()
      .insert('circle', '.outline')
      .classed('ring', true)
      .attr
        cx: 0
        cy: 0
        'stroke-width': nodeRingStrokeSize + 'px'

      circles
      .attr
        r: (node) -> node.radius + 4

      circles.exit().remove()

    onTick: noop
  )

  removeNodeRing = new neo.Renderer(
    onGraphChange: (selection) ->
      circles = selection.selectAll('circle.context-ring').data((node) -> [node])
      circles.enter()
      .insert('circle', '.outline')
      .classed('small-ring', true)
      .attr
        cx: (node) -> menuItemX node.radius, 19
        cy: (node) -> menuItemY node.radius, 19
        'stroke-width': nodeRingStrokeSize + 'px'
        r: 10

#      circles
#      .attr
#        r: (node) -> node.radius + 4

      circles.exit().remove()

    onTick: noop
  )

  arrowPath = new neo.Renderer(
    name: 'arrowPath'
    onGraphChange: (selection, viz) ->
      paths = selection.selectAll('path.outline').data((rel) -> [rel])

      paths.enter()
      .append('path')
      .classed('outline', true)

      paths
      .attr('fill', (rel) -> viz.style.forRelationship(rel).get('color'))
      .attr('stroke', 'none')

      paths.exit().remove()

    onTick: (selection) ->
      selection.selectAll('path')
      .attr('d', (d) -> d.arrow.outline(d.shortCaptionLength))
  )

  relationshipType = new neo.Renderer(
    name: 'relationshipType'
    onGraphChange: (selection, viz) ->
      texts = selection.selectAll("text").data((rel) -> [rel])

      texts.enter().append("text")
      .attr("text-anchor": "middle")
      .attr('pointer-events': 'none')

      texts
      .attr('font-size', (rel) -> viz.style.forRelationship(rel).get('font-size'))
      .attr('fill', (rel) -> viz.style.forRelationship(rel).get('text-color-' + rel.captionLayout))

      texts.exit().remove()

    onTick: (selection, viz) ->
      selection.selectAll('text')
      .attr('x', (rel) -> rel.arrow.midShaftPoint.x)
      .attr('y', (rel) -> rel.arrow.midShaftPoint.y + parseFloat(viz.style.forRelationship(rel).get('font-size')) / 2 - 1)
      .attr('transform', (rel) ->
          if rel.naturalAngle < 90 or rel.naturalAngle > 270
            "rotate(180 #{ rel.arrow.midShaftPoint.x } #{ rel.arrow.midShaftPoint.y })"
          else
            null)
      .text((rel) -> rel.shortCaption)
  )

  relationshipOverlay = new neo.Renderer(
    name: 'relationshipOverlay'
    onGraphChange: (selection) ->
      rects = selection.selectAll('path.overlay').data((rel) -> [rel])

      rects.enter()
        .append('path')
        .classed('overlay', true)

      rects.exit().remove()

    onTick: (selection) ->
      band = 16

      selection.selectAll('path.overlay')
        .attr('d', (d) -> d.arrow.overlay(band))
  )

  neo.renderers.node.push(nodeOutline)
  neo.renderers.node.push(nodeCaption)
  neo.renderers.node.push(nodeRing)
  neo.renderers.node.push(removeNode)
  neo.renderers.node.push(expandNode)
  neo.renderers.node.push(unlockNode)
#  neo.renderers.node.push(editNode)
  neo.renderers.node.push(deleteNode)
#  neo.renderers.node.push(removeNodeRing)
#  neo.renderers.node.push(expandNodeRing)
  neo.renderers.relationship.push(arrowPath)
  neo.renderers.relationship.push(relationshipType)
  neo.renderers.relationship.push(relationshipOverlay)
