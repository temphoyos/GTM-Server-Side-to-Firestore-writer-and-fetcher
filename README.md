#GTM Server-Side to Firestore writer and fetcher

The main purpose of this implementation is to leverage the Firestore API from Google Tag Manager Server-Side in order to generate a user database in Firestore that will keep track of each user's purchases. Each Firestore document will be tied to a single user and will be updated with each transaction. The content of each Firestore document will be pulled into Google Tag Manager Client-Side and from there pushed to the dataLayer. 

##How to deploy this implementation
