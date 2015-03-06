# ForgotPasswordScreenlet for iOS

## Important Note

*This product is under heavy development and its features aren't ready for use in production. It's being made public only to allow developers to preview the technology.*

## Requirements

- XCode 6.0 or above
- iOS 8 SDK
- Liferay Portal 6.2 CE or EE
- Mobile Widgets plugin installed

## Compatibility

- iOS 7 and above

## Features

The `ForgotPasswordScreenlet` can send an email a registered user with their new password or a password reset link, depending on the server configuration. The available authentication methods are:

- Email address
- Screen name
- User id

## Module

- Auth

## Themes

- Default
- Flat7

![The `ForgotPasswordScreenlet` with the Default and Flat7 themes.](Images/forgotpwd.png)

## Portal Configuration

To use the `ForgotPasswordScreenlet`, you must allow users to request new passwords in the portal. The next sections show you how to do this.

### Authentication Method

Note that the authentication method configured in the portal can be different than that used by this screenlet. For example, it's *perfectly fine* to use `screenName` for sign in authentication, but allow users to recover their password using the `email` authentication method.

### Password Reset

Password recovery depends on the authentication settings in the portal:

![Checkboxes for the password recovery features in Liferay Portal.](Images/password-reset.png)

If both of these options are unchecked, then password recovery is disabled. If both options are checked, an email containing a password reset link is sent when a user requests it. If only the first option is checked, an email containing a new password is sent when a user requests it.

For more details on authentication in Liferay Portal, please refer to the [Configuring Portal Settings](https://dev.liferay.com/discover/portal/-/knowledge_base/6-2/configuring-portal-settings) section of the User Guide.

### Anonymous Request

An anonymous request can be done without the user being logged in. However, authentication is needed to call the API. To allow this operation, it's recommended that the portal administrator create a specific user with minimal permissions.

## Attributes

| Attribute | Data type | Explanation |
|-----------|-----------|-------------| 
| `anonymousApiUserName` | `string` | The user name, email address, or userId (depending on the portal's authentication method) to use for authenticating the request. |
| `anonymousApiPassword` | `string` | The password to use to authenticate the request. |
| `companyId` | `number` | When set, the authentication is done for a user within the specified company. If the value is `0`, the company specified in `LiferayServerContext` is used. |
| `authMethod` | `string` | The authentication method that is presented to the user. This can be `email`, `screenName`, or `userId`. |

## Delegate

The `ForgotPasswordScreenlet` delegates some events to an object that conforms to the `ForgotPasswordScreenletDelegate` protocol. This protocol lets you implement the following methods:

- `onForgotPasswordResponse(boolean)`: Called when a password reset email is successfully sent. The Boolean parameter indicates whether the email contains the new password or a password reset link.
- `onForgotPasswordError(error)`: Called when an error occurs in the process. The `NSError` object describes the error.

