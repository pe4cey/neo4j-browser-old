/**
 * Copyright (c) 2002-2016 "Neo Technology,"
 * Network Engine for Objects in Lund AB [http://neotechnology.com]
 *
 * This file is part of Neo4j.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _integer = require('./integer');

var _driver = require('./driver');

var _driver2 = _interopRequireDefault(_driver);

var _version = require('../version');

var _graphTypes = require('./graph-types');

var USER_AGENT = "neo4j-javascript/" + _version.VERSION;

exports['default'] = {
  driver: function driver(url, token) {
    return new _driver2['default'](url, USER_AGENT, token);
  },
  int: _integer.int,
  isInt: _integer.isInt,
  auth: {
    basic: function basic(username, password) {
      return { scheme: "basic", principal: username, credentials: password };
    }
  },
  types: {
    Node: _graphTypes.Node,
    Relationship: _graphTypes.Relationship,
    UnboundRelationship: _graphTypes.UnboundRelationship,
    PathSegment: _graphTypes.PathSegment,
    Path: _graphTypes.Path
  }
};
module.exports = exports['default'];