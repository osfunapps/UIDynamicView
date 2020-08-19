//
//  PointerExtensions.swift
//  GeneralStreamiOS
//
//  Created by Oz Shabat on 12/02/2020.
//  Copyright © 2020 osCast. All rights reserved.
//

import Foundation

extension UnsafeBufferPointer where Element == UInt8 {
    
    /// Will read 4 bytes from a buffer to a single (little endian) int
    public func readUInt32LE(offset: Int) -> UInt32 {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 4])
        let uint32Val = arr!.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 }.pointee
        arr = nil
        return UInt32(littleEndian: uint32Val)
    }
    
    /// Will read single byte from a buffer to a single (big endian) int
    public func readUInt8BE(offset: Int) -> UInt8 {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 1])
        let bigEndianValue = arr!.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }.pointee
        arr = nil
        return UInt8(bigEndian: bigEndianValue)
    }
    
    /// Will read 2 bytes from a buffer to a single (big endian) int
    public func readUInt16BE(offset: Int) -> UInt16 {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 2])
        let bigEndianValue = arr!.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 }.pointee
        arr = nil
        return UInt16(bigEndian: bigEndianValue)
    }
    
    /// Will read 2 bytes from a buffer to a single (little endian) int
    public func readUInt16LE(offset: Int) -> Int {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 2])
        let uint16Val = arr!.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 }.pointee
        arr = nil
        return Int(UInt16(littleEndian: uint16Val))
    }
    
    /// Will read 4 bytes from a buffer to a single (big endian) int
    public func readUInt32BE(offset: Int) -> UInt32 {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 4])
        let bigEndianValue = arr!.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 }.pointee
        arr = nil
        return UInt32(bigEndian: bigEndianValue)
    }
    
    /// Will read 8 bytes from a buffer to a single (big endian) int
    public func readUInt64LE(offset: Int) -> UInt64 {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + 8])
        let uint64Val = arr!.baseAddress!.withMemoryRebound(to: UInt64.self, capacity: 1) { $0 }.pointee
        arr = nil
        return UInt64(littleEndian: uint64Val)
    }
    
    public func toUTFString() -> String? {
        if let string = String(bytes: self, encoding: .utf8) {
            return string
        } else {
            print("not a valid UTF-8 sequence")
            return ""
        }
    }
    
    /// Will read bytes to string
    public func readString(offset: Int, dataLength: Int) -> String {
        var arr: UnsafeBufferPointer<UInt8>? = UnsafeBufferPointer<UInt8>.init(rebasing: self[offset...offset + dataLength])
        let str = arr!.toUTFString()!
        arr = nil
        return str
    }
    
}

extension Int {

    
    /// Will break a number to a single byte and add it to a data object
    public func writeUInt8() -> Data {
        return Data([UInt8(self)])
    }
    
    /// Will break a number to 2 (big endian) bytes and add them to a data object
       public func writeUInt16BE() -> Data {
           let uInt8Value0 = UInt8(self >> 8)
           let uInt8Value1 = UInt8(self & 0x00ff)
           return Data([uInt8Value0, uInt8Value1])
       }
       
    /// Will break a number to 2 (little endian) byte array and add it to a data object
    public func writeUInt16LE() -> Data {
        let byte1 = UInt8(self & 0xff)
        let byte2 = UInt8(self >> 8 & 0xff)
        return Data([byte1, byte2])
    }
    
    /// Will break a number to 4 (big endian) bytes and add it to a data object
      public func writeUInt32BE() -> Data {
          let __data = UInt32(self)
          let byte1 = UInt8(self & 0x000000FF)         // 10
          let byte2 = UInt8((self & 0x0000FF00) >> 8)  // 154
          let byte3 = UInt8((self & 0x00FF0000) >> 16) // 0
          let intt = (__data & (0xFF000000 as UInt32))
          let byte4 = UInt8(intt >> 24) // 0
          return Data([byte4, byte3, byte2, byte1])
      }
    
    /// Will break a number to 4 (little endian) bytes and add them to a data object
    public func writeUInt32LE() -> Data {
        let byte1 = UInt8(self & 0xff)
        let byte2 = UInt8(self >> 8 & 0xff)
        let byte3 = UInt8(self >> 16 & 0xff)
        let byte4 = UInt8(self >> 24 & 0xff)
        return Data([byte1, byte2, byte3, byte4])
    }
    
    
    /// Will break a float to 2 (little endian) bytes and add it to a data object
    public func writeFloat32LE(valToAdd: Float) -> Data {
        return Int(valToAdd.bitPattern).writeUInt32LE()
    }
    
    /// Will break a number to 8 (little endian) bytes and add it to a data object
    public func writeUInt64LE() -> Data {
        let byte1 = UInt8(self & 0xff)
        let byte2 = UInt8(self >> 8 & 0xff)
        let byte3 = UInt8(self >> 16 & 0xff)
        let byte4 = UInt8(self >> 24 & 0xff)
        let byte5 = UInt8(self >> 32 & 0xff)
        let byte6 = UInt8(self >> 40 & 0xff)
        let byte7 = UInt8(self >> 48 & 0xff)
        let byte8 = UInt8(self >> 56 & 0xff)
        return Data([byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8])
    }
}


extension Array where Element == UInt8  {
    
    // Will break a number to 2 (big endian) bytes and add them to the buffer starting a given offset
    public mutating func writeUInt16BE(number: Int, offset: Int) {
        self[offset] = UInt8(number >> 8)
        self[offset+1] = UInt8(number & 0x00ff)
    }
    
    // Will break a number to 2 (little endian) bytes and add them to the buffer starting a given offset
    public mutating func writeUInt16LE(number: Int, offset: Int) {
        self[offset] = UInt8(number & 0xff)
        self[offset + 1] = UInt8(number >> 8 & 0xff)
    }
    
    /// Will break a number to 4 (little endian) bytes and add them to the buffer starting a given offset
    public mutating func writeUInt32LE(number: Int64, offset: Int) {
        self[offset] = UInt8(number & 0xff)
        self[offset + 1] = UInt8(number >> 8 & 0xff)
        self[offset + 2] = UInt8(number >> 16 & 0xff)
        self[offset + 3] = UInt8(number >> 24 & 0xff)
    }
    
    
    /// Will break a number to 8 (little endian) bytes and add them to the buffer starting a given offset
    public mutating func writeUInt64LE(number: Int, offset: Int) {
        self[offset] = UInt8(number & 0xff)
        self[offset + 1] = UInt8(number >> 8 & 0xff)
        self[offset + 2] = UInt8(number >> 16 & 0xff)
        self[offset + 3] = UInt8(number >> 24 & 0xff)
        self[offset + 4] = UInt8(number >> 32 & 0xff)
        self[offset + 5] = UInt8(number >> 40 & 0xff)
        self[offset + 6] = UInt8(number >> 48 & 0xff)
        self[offset + 7] = UInt8(number >> 56 & 0xff)
    }
    
    
}
