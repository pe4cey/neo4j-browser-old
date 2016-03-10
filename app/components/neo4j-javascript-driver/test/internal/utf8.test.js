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
 
var utf8 = require('../../lib/v1/internal/utf8');
var buffers = require('../../lib/v1/internal/buf');

describe('utf8', function() {
  it('should have a nice clean buffer position after serializing', function() {
    // When
    var buffer = utf8.encode("hello, world!");

    // Then
    expect( buffer.position ).toBe( 0 );
  });

  it('should read/write utf8', function() {
    expect( packAndUnpack( "" ) ).toBe( "" );
    expect( packAndUnpack( "åäö123" ) ).toBe( "åäö123"  );
  });

  it('should decode utf8 from a complete combined buffer', function() {
    // Given
    var msg = "asåfqwer";
    var buf = utf8.encode(msg);
    var bufa = buf.readSlice(3);
    var bufb = buf.readSlice(3);
    var bufc = buf.readSlice(3);
    var combined = new buffers.CombinedBuffer( [bufa, bufb, bufc] );

    // When
    var decoded = utf8.decode(combined, combined.length);

    // Then
    expect(decoded).toBe(msg);
  });

  it('should decode utf8 from part of a combined buffer', function() {
    // Given
    var msg = "asåfq";
    var expectMsg = msg.substring(0, msg.length-1);
    var buf = utf8.encode(msg);
    var bufa = buf.readSlice(3);
    var bufb = buf.readSlice(3);
    var unrelatedData = buffers.alloc(3);
    var combined = new buffers.CombinedBuffer( [bufa, bufb, unrelatedData] );

    // When 
    // We read all but the unrelatedData and the last character of bufb
    var decoded = utf8.decode(combined, combined.length - 1 - unrelatedData.length );

    // Then
    expect(decoded).toBe(expectMsg);
  });
});

function packAndUnpack( str ) {
  var buffer = utf8.encode( str );
  return utf8.decode( buffer, buffer.length );
}
