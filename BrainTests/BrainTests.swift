//
//  BrainTests.swift
//  BrainTests
//
//  Created by Joachim Neumann on 28/09/2021.
//

import XCTest
@testable import Calculator

class BrainTests: XCTestCase {
    let digitsInSmallDisplay = TE().digitsInSmallDisplay
    let brain = Brain()
    
    func test() throws {
        let digits = 16
        /// 0
        brain.reset()
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0")

        // 12
        brain.reset()
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1")
        brain.digit(2, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "12")

        // 01
        brain.reset()
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1")

        /// 1234567890123456
        brain.reset()
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(9, digits: digits)
        brain.zero(digits: digits)
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "123456789012345")
        XCTAssertEqual(brain.exponent(digits), nil)
        brain.digit(6, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1234567890123456")
        XCTAssertEqual(brain.exponent(digits), nil)
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1,234567890123")
        XCTAssertEqual(brain.exponent(digits), "e16")

        /// -12345678901234
        brain.reset()
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(9, digits: digits)
        brain.zero(digits: digits)
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.sMantissa(digits), "-12345678901234")


        /// 77777777777777777
        brain.reset()
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "777777777")
        XCTAssertEqual(brain.exponent(digits), nil)
        XCTAssertEqual(brain.lMantissa(digits), "777777777")
        XCTAssertEqual(brain.exponent(digits), nil)
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "7777777777")
        XCTAssertEqual(brain.exponent(digits), nil)
        XCTAssertEqual(brain.lMantissa(digits), "7777777777")
        XCTAssertEqual(brain.exponent(digits), nil)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "7,777777777777")
        XCTAssertEqual(brain.exponent(digits), "e16")
        XCTAssertEqual(brain.lMantissa(digits), "7,777777777777")
        XCTAssertEqual(brain.exponent(digits), "e16")
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "7,777777777777")
        XCTAssertEqual(brain.exponent(digits), "e17")
        XCTAssertEqual(brain.lMantissa(digits), "7,777777777777")
        XCTAssertEqual(brain.exponent(digits), "e17")

        
        
        /// -123456789012345
        brain.reset()
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(9, digits: digits)
        brain.zero(digits: digits)
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.sMantissa(digits), "-123456789012345")

        /// -1234567890123456
        brain.reset()
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.digit(7, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(9, digits: digits)
        brain.zero(digits: digits)
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(3, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.sMantissa(digits), "-1,23456789012")
        XCTAssertEqual(brain.exponent(digits), "e15")

        /// +/-
        brain.reset()
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "7")
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.sMantissa(digits), "-7")

        /// -0,7
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.sMantissa(digits), "0,")
        brain.digit(7, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0,7")
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.sMantissa(digits), "-0,7")

        brain.reset()
        brain.digit(3, digits: digits)
        brain.operationWorker("EE")
        brain.digit(7, digits: digits)
        brain.digit(7, digits: digits)
        brain.operationWorker("+/-")
        brain.operationWorker("=")
        XCTAssertEqual(brain.sMantissa(digits), "3,0")
        XCTAssertEqual(brain.exponent(digits), "e-77")

        /// 888888
        brain.reset()
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "8888888")
        XCTAssertEqual(brain.lMantissa(digits), "8888888")

        
        /// memory
        brain.reset()
        brain.digit(1, digits: digits)
        brain.digit(2, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "12")
        brain.clearMemory()
        XCTAssertEqual(brain.sMantissa(digits), "12")
        brain.addToMemory()
        XCTAssertEqual(brain.sMantissa(digits), "12")
        brain.addToMemory()
        XCTAssertEqual(brain.sMantissa(digits), "12")
        brain.getMemory()
        XCTAssertEqual(brain.sMantissa(digits), "24")
        brain.subtractFromMemory()
        XCTAssertEqual(brain.sMantissa(digits), "24")
        brain.getMemory()
        XCTAssertEqual(brain.sMantissa(digits), "0")
        
        /// 0,0000010
        brain.reset()
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.comma()
        XCTAssertEqual(brain.sMantissa(digits), "0,")
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0,0")
        brain.zero(digits: digits)
        brain.zero(digits: digits)
        brain.zero(digits: digits)
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0,00000")
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0,000001")
        brain.zero(digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "0,0000010")

        /// reset
        brain.reset()
        XCTAssertEqual(brain.sMantissa(digits), "0")

        /// 1 e -15
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.sMantissa(digits), "0,")
        var res = "0,"
        for _ in 1..<digitsInSmallDisplay-1 {
            res += "0"
            brain.zero(digits: digits)
            XCTAssertEqual(brain.sMantissa(digits), res)
        }
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1,0")
        XCTAssertEqual(brain.exponent(digits), "e-\(digitsInSmallDisplay-1)")

        /// 32456.2244
        brain.reset()
        XCTAssertEqual(brain.sMantissa(digits), "0")
        brain.digit(3, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(5, digits: digits)
        brain.digit(6, digits: digits)
        brain.comma()
        brain.digit(2, digits: digits)
        brain.digit(2, digits: digits)
        brain.digit(4, digits: digits)
        brain.digit(4, digits: digits)
        res = "32456,2244"
        XCTAssertEqual(brain.sMantissa(digits), "32456,2244")
        
        /// 32456.2244333333333333333333333333
        for _ in res.count..<digitsInSmallDisplay+20 {
            res += "3"
            brain.digit(3, digits: digits)
            /// prefix + 1 for the comma
            XCTAssertEqual(brain.sMantissa(digits), String(res.prefix(digitsInSmallDisplay+1)))
        }

        /// 1/7*7 --> has more digits?
        brain.reset()
        brain.digit(7, digits: digits)
        brain.operationWorker("One_x")
        brain.operationWorker("x")
        brain.digit(7, digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.sMantissa(digits), "1")
        XCTAssertEqual(brain.hasMoreDigits(digits), false)

        /// 9 %%%% ^2 ^2 ^2
        brain.reset()
        brain.digit(9, digits: digits)
        brain.operationWorker("%")
        XCTAssertEqual(brain.sMantissa(digits), "0,09")
        brain.operationWorker("%")
        XCTAssertEqual(brain.sMantissa(digits), "0,0009")
        brain.operationWorker("%")
        brain.operationWorker("%")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")

        /// pi
        brain.reset()
        brain.operationWorker("π")
        let correct = "3,1415926535897932384626433832795028841971"
        XCTAssertEqual(brain.debugLastDouble, Double.pi)
        XCTAssertEqual(brain.sMantissa(digits), String(correct.prefix(digitsInSmallDisplay+1)))
        let c = brain.lMantissa(correct.count)!
        XCTAssertEqual(String(c.prefix(correct.count)), correct)

        /// 1+pi
        brain.reset()
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.sMantissa(digits), "1")
        XCTAssertEqual(brain.debugLastDouble, 1.0)
        brain.operationWorker("+")
        XCTAssertEqual(brain.sMantissa(digits), "1")
        XCTAssertEqual(brain.debugLastDouble, 1.0)
        brain.operationWorker("π")
        XCTAssertEqual(brain.debugLastDouble, Double.pi)
        XCTAssertEqual(brain.sMantissa(digits), String("3,1415926535897932384626433832795028841971".prefix(digitsInSmallDisplay+1)))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastDouble, 1.0+Double.pi)
        XCTAssertEqual(brain.sMantissa(digits), String("4,1415926535897932384626433832795028841971".prefix(digitsInSmallDisplay+1)))

        /// 1/10 and 1/16
        brain.reset()
        brain.digit(1, digits: digits)
        brain.zero(digits: digits)
        XCTAssertEqual(brain.debugLastDouble, 10.0)
        XCTAssertEqual(brain.sMantissa(digits), "10")
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastDouble, 0.1)
        brain.digit(1, digits: digits)
        brain.digit(6, digits: digits)
        XCTAssertEqual(brain.debugLastDouble, 16.0)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastDouble, 0.0625)
        
        /// 1+2+5+2= + 1/4 =
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.digit(2, digits: digits)
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("3"))
        brain.digit(5, digits: digits)
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("8"))
        brain.digit(2, digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.digit(4, digits: digits)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("0.25"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10.25"))
        
        /// 1+2*4=
        brain.reset()
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2, digits: digits)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.digit(4, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("9"))

        /// 2*3*4*5=
        brain.reset()
        brain.digit(2, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.operationWorker("x")
        brain.digit(3, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("3"))
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("6"))
        brain.digit(4, digits: digits)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("24"))
        brain.digit(5, digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("120"))

        /// 1+2*4
        brain.reset()
        brain.digit(1, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2, digits: digits)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.digit(4, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("9"))
        brain.digit(1, digits: digits)
        brain.zero(digits: digits)
        brain.zero(digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("100"))
        /// User: =
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("109"))
        
        brain.reset()
        brain.operationWorker("π")
        brain.operationWorker("x")
        brain.digit(2, digits: digits)
        brain.operationWorker("=")
        
        brain.reset()
        brain.digit(2, digits: digits)
        brain.operationWorker("x^y")
        brain.digit(1, digits: digits)
        brain.zero(digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1024"))

        brain.reset()
        brain.digit(1, digits: digits)
        brain.zero(digits: digits)
        brain.operationWorker("y^x")
        brain.digit(2, digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1024"))
        
        /// 2x(6+4)
        brain.reset()
        brain.digit(2, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        XCTAssertEqual(brain.no, 0)
        brain.operationWorker("x")
        XCTAssertEqual(brain.no, 1)
        brain.operationWorker("(")
        XCTAssertEqual(brain.no, 2)
        brain.digit(6, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("6"))
        XCTAssertEqual(brain.nn, 2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.no, 3)
        brain.digit(4, digits: digits)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        XCTAssertEqual(brain.nn, 3)
        brain.operationWorker(")")
        XCTAssertEqual(brain.no, 1)
        XCTAssertEqual(brain.nn, 2)
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("20"))

        /// 2x(6+4*(5+9))
        brain.reset()
        brain.digit(2, digits: digits)
        brain.operationWorker("x")
        brain.operationWorker("(")
        brain.digit(6, digits: digits)
        brain.operationWorker("+")
        brain.digit(4, digits: digits)
        brain.operationWorker("x")
        brain.operationWorker("(")
        brain.digit(5, digits: digits)
        brain.operationWorker("+")
        brain.digit(9, digits: digits)
        brain.operationWorker(")")
        brain.operationWorker(")")
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("124"))

        /// 1+2=3
        brain.reset()
        brain.digit(1, digits: digits)
        brain.operationWorker("+")
        brain.digit(2, digits: digits)
        brain.operationWorker("=")
        brain.digit(2, digits: digits)
        XCTAssertEqual(brain.nn, 1)
        
        brain.reset()
        brain.operationWorker("π")
        XCTAssertEqual(brain.debugLastDouble, 3.14159265358979, accuracy: 0.00000001)

        brain.reset()
        brain.zero(digits: digits)
        brain.comma()
        brain.zero(digits: digits)
        brain.digit(1, digits: digits)
        brain.operationWorker("/")
        brain.digit(1, digits: digits)
        brain.operationWorker("EE")
        brain.digit(4, digits: digits)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastDouble, 0.000001)

        brain.reset()
        brain.digit(8, digits: digits)
        brain.digit(8, digits: digits)
        brain.operationWorker("%")
        XCTAssertEqual(brain.debugLastDouble, 0.88)

        brain.reset()
        brain.digit(4, digits: digits)
        brain.zero(digits: digits)
        brain.operationWorker("+")
        brain.digit(1, digits: digits)
        brain.zero(digits: digits)
        brain.operationWorker("%")
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastDouble, 44.0)
    }
}
