//
//  ExerciseAmountFormatter.swift
//  WatchSport
//

import Foundation

enum ExerciseAmountFormatter {
    static func repetitions(_ amount: Double) -> String {
        amount.formatted(.number.precision(.fractionLength(0)))
    }

    static func distance(_ meters: Double) -> String {
        if meters >= 1_000 {
            return formattedKilometers(meters) + " km"
        }

        return formattedMeters(meters) + " m"
    }

    static func distanceProgress(completedMeters: Double, targetMeters: Double) -> String {
        if targetMeters >= 1_000 {
            return "\(formattedKilometers(completedMeters)) de \(formattedKilometers(targetMeters)) km"
        }

        return "\(formattedMeters(completedMeters)) de \(formattedMeters(targetMeters)) m"
    }

    private static func formattedKilometers(_ meters: Double) -> String {
        (meters / 1_000).formatted(.number.precision(.fractionLength(0...1)))
    }

    private static func formattedMeters(_ meters: Double) -> String {
        meters.formatted(.number.precision(.fractionLength(0)))
    }
}
