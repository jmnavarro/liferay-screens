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


class SessionContext_Basic_Tests: XCTestCase {

	override func tearDown() {
		SessionContext.clearSession()

		super.tearDown()
	}

	func test_CreateSession_ShouldReturnTheSession() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		XCTAssertEqual("username", session.username)
		XCTAssertEqual("password", session.password)
	}

	func test_CreateSession_ShouldStoreUserAttributes() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: ["key":"value"])

		XCTAssertEqual("value", (SessionContext.userAttribute("key") ?? "") as String)
	}

	func test_CurrentUserName_ShouldReturnTheUserName_WhenSessionIsCreated() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		XCTAssertNotNil(SessionContext.currentUserName)
		XCTAssertEqual("username", SessionContext.currentUserName!)
	}

	func test_CurrentPassword_ShouldReturnThePassword_WhenSessionIsCreated() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		XCTAssertNotNil(SessionContext.currentPassword)
		XCTAssertEqual("password", SessionContext.currentPassword!)
	}

	func test_CurrentUserName_ShouldReturnNil_WhenSessionIsNotCreated() {
		SessionContext.clearSession()
		XCTAssertNil(SessionContext.currentUserName)
	}

	func test_CurrentPassword_ShouldReturnNil_WhenSessionIsNotCreated() {
		SessionContext.clearSession()
		XCTAssertNil(SessionContext.currentPassword)
	}

	func test_HasSession_ShouldReturnTrue_WhenSessionIsCreated() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		XCTAssertTrue(SessionContext.hasSession)
	}

	func test_HasSession_ShouldReturnFalse_WhenSessionIsNotCreated() {
		SessionContext.clearSession()
		XCTAssertFalse(SessionContext.hasSession)
	}

	func test_CreateSessionFromCurrentSession_ShouldReturnNil_WhenSessionIsNotCreated() {
		SessionContext.clearSession()
		XCTAssertNil(SessionContext.createSessionFromCurrentSession())
	}

	func test_CreateSessionFromCurrentSession_ShouldReturnNewSession_WhenSessionIsCreated() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		let createdSession = SessionContext.createSessionFromCurrentSession()
		XCTAssertNotNil(createdSession)
		XCTAssertFalse(session == createdSession!)

		createdSession!.username = "modified-username"
		createdSession!.password = "modified-password"

		XCTAssertEqual("modified-username", createdSession!.username)
		XCTAssertEqual("modified-password", createdSession!.password)

		XCTAssertEqual("username", SessionContext.currentUserName!)
		XCTAssertEqual("password", SessionContext.currentPassword!)
	}

	func test_CreateBatchSessionFromCurrentSession_ShouldReturnNewSession_WhenSessionIsCreated() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: [:])

		let createdSession = SessionContext.createBatchSessionFromCurrentSession()
		XCTAssertNotNil(createdSession)
		XCTAssertFalse(session == createdSession!)

		createdSession!.username = "modified-username"
		createdSession!.password = "modified-password"

		XCTAssertEqual("modified-username", createdSession!.username)
		XCTAssertEqual("modified-password", createdSession!.password)

		XCTAssertEqual("username", SessionContext.currentUserName!)
		XCTAssertEqual("password", SessionContext.currentPassword!)
	}

	func test_CreateBatchSessionFromCurrentSession_ShouldReturnNil_WhenSessionIsNotCreated() {
		SessionContext.clearSession()
		XCTAssertNil(SessionContext.createBatchSessionFromCurrentSession())
	}

	func test_ClearSession_ShouldEmptyTheSession() {
		let session = SessionContext.createSession(
				username: "username",
				password: "password",
				userAttributes: ["k":"v"])

		SessionContext.clearSession()

		XCTAssertNil(SessionContext.currentUserName)
		XCTAssertNil(SessionContext.currentPassword)
		XCTAssertNil(SessionContext.userAttribute("k"))
		XCTAssertFalse(SessionContext.hasSession)
	}



}
