//
//  File.swift
//
//
//  Created by Themis Wang on 2023-11-28.
//

import Foundation
import FirebaseRemoteConfigInterop

protocol CrashlyticsPersistentLog: NSObject {
  func updateRolloutsStateToPersistence(rolloutAssignments: [RolloutAssignment])
}

@objc(FIRCLSRemoteConfigManager)
public class CrashlyticsRemoteConfigManager: NSObject {
  static let maxRolloutAssignment = 128
  static let maxParameterValueLength = 256

  var remoteConfig: RemoteConfigInterop
  var rolloutAssignment: [RolloutAssignment] = []
  weak var persistenceDelegate: CrashlyticsPersistentLog?

  @objc public init(remoteConfig: RemoteConfigInterop) {
    self.remoteConfig = remoteConfig
  }

  public func updateRolloutsState(rolloutsState: RolloutsState) {
    // probably want to sync this
    rolloutAssignment = validateRolloutAssignment(assignments: Array(rolloutsState.assignments))

    // writing into persistance
    // here we probably need to import FIRCLSUserLogging, the dependency will be really hard to
    // setup
  }
}

private extension CrashlyticsRemoteConfigManager {
  func validateRolloutAssignment(assignments: [RolloutAssignment]) -> [RolloutAssignment] {
    var validatedAssignments = assignments
    if assignments.count > CrashlyticsRemoteConfigManager.maxRolloutAssignment {
      validatedAssignments =
        Array(assignments[..<CrashlyticsRemoteConfigManager.maxRolloutAssignment])
    }

    _ = validatedAssignments.map { assignment in
      if assignment.parameterValue.count > CrashlyticsRemoteConfigManager.maxParameterValueLength {
        let upperBound = String.Index(
          utf16Offset: CrashlyticsRemoteConfigManager.maxParameterValueLength,
          in: assignment.parameterValue
        )
        let slicedParameterValue = assignment.parameterValue[..<upperBound]
        assignment.parameterValue = String(slicedParameterValue)
      }
    }

    return validatedAssignments
  }
}
