/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
import XCTest


class LoginScreenlet_ByEmail_Tests: BaseLoginScreenletTestCase {

	func test_Successful() {
		scenario ("LoginScreenlet by email should work") {
			given ("a configured login screenlet") {
				with ("auth method set to email") {
					self.screenlet!.basicAuthMethod = BasicAuthMethod.Email.rawValue
				}
				and ("email and password entered by the user") {
					self.screenlet!.viewModel.userName = "test@liferay.com"
					self.screenlet!.viewModel.password = "test"
				}
				and ("no previous session created") {
					SessionContext.logout()
				}
				and ("server returns ok") {
					mockServer.stubService("get-user-by-email-address",
							withResult: mockServer.loginOK())
				}
			}
			when ("the request is sent and the response is received") {
				self.screenlet!.delegate = TestLoginScreenletDelegate() { result in
					done("login response received", withResult: result)
				}
				self.screenlet!.performDefaultAction()
			}
			eventually ("the state of the screenlet should be consistent", { result in
				assertThat("the error should be nil") {
					XCTAssertFalse(result is NSError)
				}
				assertThat("the attributes should be populated") {
					XCTAssertTrue(result is [String:AnyObject])

					let attrs = result as! [String:AnyObject]

					XCTAssertTrue(attrs.count > 0)
					XCTAssertNotNil(attrs["emailAddress"])
					XCTAssertEqual("test@liferay.com", attrs["emailAddress"] as? String)
				}
				assertThat("the session should be established") {
					XCTAssertTrue(SessionContext.isLoggedIn)
					XCTAssertNotNil(SessionContext.currentContext)
				}
				assertThat("the current user name should be the email address") {
					XCTAssertNotNil(SessionContext.currentContext?.basicAuthUsername)
					XCTAssertEqual("test@liferay.com", SessionContext.currentContext!.basicAuthUsername!)
				}
				assertThat("the current password should be available") {
					XCTAssertNotNil(SessionContext.currentContext?.basicAuthPassword)
					XCTAssertEqual("test", SessionContext.currentContext!.basicAuthPassword!)
				}
			},
			.TestAndWaitFor("login response received", self))
		}
	}

	func test_StoreCredentials() {
		let loginDelegate = TestLoginScreenletDelegate()
		let credentialsStoreMock = CredentialStoreMock()
		credentialsStoreMock.hasData = false

		scenario ("LoginScreenlet by email store credentials") {
			given ("a configured login screenlet") {
				with ("auth method set to email") {
					self.screenlet!.basicAuthMethod = BasicAuthMethod.Email.rawValue
				}
				and ("email and password entered by the user") {
					self.screenlet!.viewModel.userName = "test@liferay.com"
					self.screenlet!.viewModel.password = "test"
				}
				and ("store credentials flag enabled") {
					self.screenlet!.saveCredentials = true
				}
				and ("no previous session created") {
					SessionContext.logout()
				}
				and ("server returns ok") {
					mockServer.stubService("get-user-by-email-address",
							withResult: mockServer.loginOK())
				}
			}
			when ("the request is sent") {
				and ("the response is received") {
					// the mock should be set here again because when the
					// session is created in SessionContext, actual CredentialsStore
					// is created and set
					loginDelegate.onCompleted = { _ in
						SessionContext.currentContext!.credentialsStorage = CredentialsStorage(
							store: credentialsStoreMock)
					}

					// we need to complete the test when the credentials are saved.
					// This happens *after* the loginResponse is received
					loginDelegate.onCredentialsStored = {
						done("login response received", withResult: nil)
					}
					self.screenlet!.delegate = loginDelegate
				}

				self.screenlet!.performDefaultAction()
			}
			eventually ("the credentials should be stored", { result in
				assertThat ("the session mock is signaled") {
					XCTAssertTrue(credentialsStoreMock.calledStoreCredential)
					XCTAssertTrue(credentialsStoreMock.hasData)
				}
				assertThat ("the session context can load the credentials") {
					let storage = CredentialsStorage(store: credentialsStoreMock)
					XCTAssertTrue(SessionContext.loadStoredCredentials(storage))
				}
				assertThat("onCredentialsSaved delegate is called") {
					XCTAssertTrue((self.screenlet!.delegate as! TestLoginScreenletDelegate).credentialsSavedCalled)
				}
			},
			.TestAndWaitFor("login response received", self))
		}
	}

	func test_Failed_WrongCredentials() {
		scenario ("LoginScreenlet by email should fail when credentials are wrong") {
			given ("a configured login screenlet") {
				with ("auth method set to email") {
					self.screenlet!.basicAuthMethod = BasicAuthMethod.Email.rawValue
				}
				and ("email and password entered by the user") {
					self.screenlet!.viewModel.userName = "test@liferay.com"
					self.screenlet!.viewModel.password = "test"
				}
				and ("no previous session created") {
					SessionContext.logout()
				}
				and ("server returns failure") {
					mockServer.stubService("get-user-by-email-address",
							withResult:mockServer.loginFailedAuthentication())
				}
			}
			when ("the request is sent and the response is received") {
				self.screenlet!.delegate = TestLoginScreenletDelegate() { result in
					done("login response received", withResult: result)
				}
				self.screenlet!.performDefaultAction()
			}
			eventually ("the state of the screenlet should be consistent", { result in
				assertThat ("the result should be an error") {
					XCTAssertTrue(result is NSError)

					let error = result as! NSError

					XCTAssertEqual("The operation couldn’t be completed. Authenticated access required"
							, error.localizedDescription)

				}
				assertThat ("the session should not be established") {
					XCTAssertFalse(SessionContext.isLoggedIn)
					XCTAssertNil(SessionContext.currentContext)
				}
			},
			.TestAndWaitFor("login response received", self))
		}
	}

}
