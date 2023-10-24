# Mailchimp OAuth Sample App

This is a simple Sinatra application that demonstrates how to set up an OAuth flow with Mailchimp's Marketing API. The app allows users to log in with their Mailchimp account, obtain an access token, and make an API call to the Mailchimp server.

## Prerequisites

- **Ruby Version**: 3.2.1

## Installation

To install the necessary dependencies, use the following command:

```bash
bundle install
```

## Usage

1. Copy the content of `environment.sample.rb` into `environment.rb`.

2. Replace `client_id` and `client_secret` in `environment.rb` with the values from your registered Mailchimp app.

3. Replace `BASE_URL` with your ngrok URL if using ngrok, or use `http://127.0.0.1:3000` for local testing.

4. Run the script using the following command:

```bash
ruby token.rb
```

## OAuth Flow

1. Navigate to `http://127.0.0.1:3000` (or your specified BASE_URL) and click "Login" to start the OAuth process.

2. You will be redirected to Mailchimp's OAuth authorization page. Log in to your Mailchimp account and grant access to the app.

3. After authorization, you will be redirected back to your app at `/oauth/mailchimp/callback`. The app will exchange the authorization code for an access token and make a test API call to Mailchimp's ping endpoint. The results will be displayed on this page.

The user's access token and server prefix are displayed on the callback page.

## Further Development

This sample app provides a foundation for implementing OAuth with the Mailchimp Marketing API. You can extend it to interact with the Mailchimp API for tasks like creating campaigns, managing audience members, and more.

For detailed information on working with the Mailchimp API, refer to the [Mailchimp API documentation](https://mailchimp.com/developer/marketing/docs/overview).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
