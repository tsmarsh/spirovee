//
//  SpirographCalculatorTests.swift
//  SpiroveeTests
//
//  Created by Tom Marsh on 12/3/24.
//

import XCTest
@testable import Spirovee

final class SpirographCalculatorTests: XCTestCase {
    
    func testBasicPointCalculation() {
        // Given
        let R: Double = 100
        let r: Double = 40
        let d: Double = 50
        
        // When
        let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        
        // Then
        XCTAssertFalse(points.isEmpty, "Points array should not be empty")
        
        // First point should be at ((R-r) + d, 0) due to initial angle of 0
        let expectedFirstX = (R-r) + d
        let expectedFirstY = 0.0
        XCTAssertEqual(points[0].x, expectedFirstX, accuracy: 0.01)
        XCTAssertEqual(points[0].y, expectedFirstY, accuracy: 0.01)
    }
    
    func testStepSizeAffectsPointCount() {
        // Given
        let R: Double = 100
        let r: Double = 40
        let d: Double = 50
        
        // When
        let pointsDefault = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        let pointsLargerStep = SpirographCalculator.calculatePoints(R: R, r: r, d: d, stepSize: 0.02)
        
        // Then
        XCTAssertGreaterThan(pointsDefault.count, pointsLargerStep.count,
                            "Larger step size should result in fewer points")
    }
    
    func testSymmetry() {
        // Given
        let R: Double = 100
        let r: Double = 25  // Use values that create a symmetric pattern
        let d: Double = 50
        
        // When
        let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        
        // Then
        // For a symmetric pattern, points at π should mirror points at 0
        let quarterIndex = points.count / 4
        let x0 = points[0].x
        let xQuarter = points[quarterIndex].x
        
        // The absolute distance from center at 0 and π/2 should be equal
        XCTAssertEqual(abs(x0), abs(xQuarter), accuracy: 0.1,
                      "Pattern should be symmetric around center")
    }
    
    func testCycleCompletion() {
        // Given
        let R: Double = 100
        let r: Double = 40
        let d: Double = 50
        
        // When
        let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        
        // Then
        // First and last points should be very close to each other
        XCTAssertEqual(points.first?.x, points.last?.x, accuracy: 0.1,
                      "First and last points should connect")
        XCTAssertEqual(points.first?.y, points.last?.y, accuracy: 0.1,
                      "First and last points should connect")
    }
}
