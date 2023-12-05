//
//  CrashlyticsRemoteConfigManagerTests.swift
//
//
//  Created by Themis Wang on 2023-11-29.
//

import XCTest
import FirebaseRemoteConfigInterop
@testable import FirebaseCrashlyticsSwift

class RemoteConfigConfigMock: RemoteConfigInterop {
  func registerRolloutsStateSubscriber(_ namespace: String,
                                       subscriber: RolloutsStateSubscriber?) {}
}

final class CrashlyticsRemoteConfigManagerTests: XCTestCase {
  let rollouts: RolloutsState = {
    let assignment1 = RolloutAssignment(
      rolloutId: "rollout_1",
      variantId: "control",
      templateVersion: 1,
      parameterKey: "my_feature",
      parameterValue: "false"
    )
    let assignment2 = RolloutAssignment(
      rolloutId: "rollout_2",
      variantId: "enabled",
      templateVersion: 1,
      parameterKey: "themis_big_feature",
      parameterValue: "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    )
    let rollouts = RolloutsState(assignmentList: [assignment1, assignment2])
    return rollouts
  }()

  let rcInterop = RemoteConfigConfigMock()

  func testRemoteConfigManagerProperlyProcessRolloutsState() throws {
    let rcManager = CrashlyticsRemoteConfigManager(remoteConfig: rcInterop)
    rcManager.updateRolloutsState(rolloutsState: rollouts)
    XCTAssertEqual(rcManager.rolloutAssignment.count, 2)

    for assignment in rollouts.assignments {
      if assignment.parameterKey == "themis_big_feature" {
        XCTAssertEqual(
          assignment.parameterValue.count,
          CrashlyticsRemoteConfigManager.maxParameterValueLength
        )
      }
    }
  }
}
