/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

#import "GACAppCheckProvider.h"

NS_ASSUME_NONNULL_BEGIN

/// A Firebase App Check provider that can exchange a debug token registered
/// in the Firebase console for a Firebase App Check token. The debug provider
/// is designed to enable testing applications on a simulator or test
/// environment.
///
/// NOTE: Do not use the debug provider in applications used by real users.
///
/// WARNING: Keep the Firebase App Check debug token secret. If you
/// accidentally share one (e.g. commit to a public source repo), remove it in
/// the Firebase console ASAP.
///
/// To use `AppCheckDebugProvider` on a local simulator:
/// 1. Configure `AppCheckDebugProviderFactory` before `FirebaseApp.configure()`:
///    ```AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())```
/// 2. Enable debug logging by adding the `-FIRDebugEnabled` launch argument to
///    the app target.
/// 3. Launch the app. A local debug token will be logged when Firebase is
///    configured. For example:
/// "[Firebase/AppCheck][I-FAA001001] Firebase App Check Debug Token:
/// '3BA09C8C-8A0D-4030-ACD5-B96D99DB73F9'".
/// 4. Register the debug token in the Firebase console.
///
/// Once the debug token is registered the debug provider will be able to provide a valid Firebase
/// App Check token.
///
/// To use `AppCheckDebugProvider` on a simulator on a build server:
/// 1. Create a new Firebase App Check debug token in the Firebase console
/// 2. Add the debug token to the secure storage of your build environment. E.g. see [Encrypted
/// secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) for GitHub Actions,
/// etc.
/// 3. Configure  `AppCheckDebugProviderFactory` before `FirebaseApp.configure()`
/// `AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())`
/// 4. Add an environment variable to the scheme with a name `FIRAAppCheckDebugToken` and value like
/// `$(MY_APP_CHECK_DEBUG_TOKEN)`.
/// 5. Configure the build script to pass the debug token as the environment variable, e.g.:
/// `xcodebuild test -scheme InstallationsExample -workspace InstallationsExample.xcworkspace \
/// MY_APP_CHECK_DEBUG_TOKEN=$(MY_SECRET_ON_CI)`
///
NS_SWIFT_NAME(AppCheckCoreDebugProvider)
@interface GACAppCheckDebugProvider : NSObject <GACAppCheckProvider>

- (instancetype)init NS_UNAVAILABLE;

/// The default initializer.
/// @param storageID A unique identifier to differentiate storage keys corresponding to the same
/// `resourceName`; may be a Firebase App Name or an SDK name.
/// @param resourceName The name of the resource protected by App Check; for a Firebase App this is
/// "projects/{project_id}/apps/{app_id}".
/// @param APIKey The Google Cloud Platform API key, if needed, or nil.
/// @param requestHooks Hooks that will be invoked on requests through this service.
/// @return An instance of `AppCheckDebugProvider` .
- (instancetype)initWithStorageID:(NSString *)storageID
                     resourceName:(NSString *)resourceName
                           APIKey:(nullable NSString *)APIKey
                     requestHooks:(nullable NSArray<GACAppCheckAPIRequestHook> *)requestHooks;

/** Return the locally generated token. */
- (NSString *)localDebugToken;

/** Returns the currently used App Check debug token. The priority:
 *  - `FIRAAppCheckDebugToken` env variable value
 *  - A previously generated token, stored locally on the device
 *  - A newly generated random token. The generated token will be stored
 *    locally for future use
 * @return The currently used App Check debug token.
 */
- (NSString *)currentDebugToken;

@end

NS_ASSUME_NONNULL_END
