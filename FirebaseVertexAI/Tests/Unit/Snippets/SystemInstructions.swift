// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import FirebaseCore
import FirebaseVertexAI
import XCTest

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
final class SystemInstructionsSnippets: XCTestCase {
  override func setUpWithError() throws {
    try FirebaseApp.configureForSnippets()
  }

  override func tearDown() async throws {
    if let app = FirebaseApp.app() {
      await app.delete()
    }
  }

  func testSystemInstruction() {
    // [START system_instruction]
    // Initialize the Vertex AI service
    let vertex = VertexAI.vertexAI()

    // Initialize the generative model
    // Specify a model that supports system instructions, like a Gemini 1.5 model
    let model = vertex.generativeModel(
      modelName: "gemini-1.5-flash",
      systemInstruction: ModelContent(role: "system", parts: "You are a cat. Your name is Neko.")
    )
    // [END system_instruction]

    // Added to silence the compiler warning about unused variable.
    let _ = String(describing: model)
  }
}
