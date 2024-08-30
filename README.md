# GTM Server-Side to Firestore writer and fetcher

The main purpose of this implementation is to leverage the Firestore API from Google Tag Manager Server-Side in order to generate a user database in Firestore that will keep track of each user's purchases. Each Firestore document will be tied to a single user and will be updated with each transaction. The content of each Firestore document will be pulled into Google Tag Manager Client-Side and from there pushed to the dataLayer. 

## How to deploy this implementation
This implementations is made up of the following building blocks: 

### Fetch POST call.js
A script that executes an http POST call from the user's browser to a given GTM Server-Side end-point. The script has been developed to be executed when a purchase event takes place. It is intented to be deployed through a GTM Client-Side CHTML Tag, so a proper trigger needs to be assigned to it.

<img width="1141" alt="fetch_post_call" src="https://github.com/user-attachments/assets/c931ab61-ed70-4ec5-9cd8-529e471ba164">


The url of this http POST call contains a userID queryString that needs to be dynamically populated. This value will be passed on to Firestore from GTM Server-Side, so the queryString will need to be updated if another identifier is going to be used. The body of this http POST call contains a series of variables that will also need to be dynamically populated. 


### Firestore writer client.tpl
A GTM Server-Side custom template that claims the incoming http request that the Fetch POST call.js generates on the purchase event. This custom template leverages the Firestore API to reach out to a given Firestore collection and update the document that is tied to the user through the userID with the purchase information that is sent over from GTM Client-Side.

In order to utilize this client template, you must import its .tpl file into your GTM Server-Side client template editor. Once imported, the following fields must be configured:

<img width="651" alt="Captura de pantalla 2024-08-30 a las 14 30 11" src="https://github.com/user-attachments/assets/506f880f-0269-47ea-ada8-d3b2a8004078">

* Request origin: https://yourclientsideenpoint.com
* Request path: /yourDesiredPath
* Google Cloud Platform Project ID: your-gcp-project-id
* Collection: Your Firestore Collection Name

Please note that the client's permissions must also be configured accordingly. 

<img width="1426" alt="Captura de pantalla 2024-08-30 a las 14 43 28" src="https://github.com/user-attachments/assets/d1678abd-33b4-40f8-8cff-a5f4514a4a62">

### Fetch GET call.js
A script that executes an http GET call from the user's browser to a given GTM Server-Side end-point. The url of this http call contains a userID queryString that needs to be dynamically populated. This value will be passed on to Firestore from GTM Server-Side, so the queryString will need to be updated if another identifier is going to be used. This same script will handle the response from GTM Server-Side and push the contents from this answer to the Google Tag Manager dataLayer.

The script is intented to be deployed through a GTM Client-Side CHTML Tag, so a proper trigger needs to be assigned to it.

<img width="1162" alt="Captura de pantalla 2024-08-30 a las 14 39 58" src="https://github.com/user-attachments/assets/182a145b-4c77-48da-a2a8-c39e10ff2bd8">

### Firestore fetcher client.tpl
A GTM Server-Side custom template that claims the incoming http request that the Fetch GET call.js generates. This custom template leverages the Firestore API to reach out to a given Firestore collection and search for a document. The name of this document will coincide with the value of the userID queryParam included in the incoming http call url. If another identifier is used, this need to be updated accordingly. Once this client receives and answer from the Firestore API, it sends over to the origin of the incoming http call.

In order to utilize this client template, you must import its .tpl file into your GTM Server-Side client template editor. Once imported, the following fields must be configured:

<img width="654" alt="Captura de pantalla 2024-08-30 a las 14 35 49" src="https://github.com/user-attachments/assets/16cc2bee-608f-43dd-a8c0-f42cbee6497e">

* Request origin: https://yourclientsideenpoint.com
* Request path: /yourDesiredPath
* Google Cloud Platform Project ID: your-gcp-project-id
* Collection: Your Firestore Collection Name

Please note that the client's permissions must also be configured accordingly. 

<img width="1427" alt="Captura de pantalla 2024-08-30 a las 14 45 00" src="https://github.com/user-attachments/assets/0a4a48d5-e4f4-4100-8414-e66f708c0307">
