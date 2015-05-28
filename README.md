# Fyber Mobile Offer API Client

This is an app consuming [Fyber Mobile Offer API](http://developer.fyber.com/content/ios/offer-wall/offer-api/).

## Structure

The app has 2 routes - `GET /` shows the form with API parameters
and `GET /results` renders the offers returned from the API.

All communication with the API is encapsulated inside `FyberClient` module:
`FyberClient.get` makes the HTTP request with the provided parameters,
validates the response with it's `X-Sponsorpay-Response-Signature`
header and (in case of success) returns the offers wrapped in simple
`FyberClient::Offer` entity objects.

A set of request parameters is represented by a `FyberClient::Params`
object which is also responsible for generating the current timestamp
and a hashkey signing the request. This object behaves like a hash so
it is constructed from the form params and passed to `FyberClient.get`.

Most of the request parameters are kept inside the git-ignored `config/.env`
file so [dotenv](https://github.com/bkeepers/dotenv) loads them up
to `ENV` before the application is started. Keeping all the configuration
inside environment variables conforms with
[The Twelve-Factor App](http://12factor.net/config) which states that
an app's config should be separated from the code.
