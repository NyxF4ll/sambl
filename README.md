# SamBl (pronounced as Sam-bal, also short for “SameBlock”)
SamBl is a neighbourhood level food delivery service that allows its user to offer to
deliver food to neighbours in return for a small charge. Put simply, it is a peer-to-peer food delivery app. The goal of our service / app is to be a cheaper and fairer alternative to traditional online food delivery services. Our main focus is on small orders from food places near the user. Moreover, we aim to incorporate fairness into our service / app with features such as having the delivery charge scale with the difficulty of the order. This would reduce the problem where a user who orders only one or two dish must pay a disproportionately high delivery charge. Furthermore, by having members of the same community deliver to one another, this app promotes interactions in the community which leads to a happier community in general.

**TLDR:**
<br>
You want to order take-away food from an outlet across the street? Order from Sambl! It gives you a list of people going to the outlet.
You are going to the food outlet? Tell others using Sambl! (You receive a small fee for every order you deliver).

**Core features of Sambl:** 
* Authentication system using Firebase authentication
* Order placement system using Cloud Firestore + Cloud functions
* Open orders creation system using Cloud Firestore + Cloud functions
* Retrieval system for lists of Hawker centres and open orders using Cloud
  Firestore
* Centralised payment system through PayPal
* Order status flags (pending, approved, purchased, delivered)
* Order status flag update system
* Google maps integration (to help with things such as selecting hawker centres,
  ranking open order, and specifying the pick-up point)
* Find user’s current location in one click.
* Automatic hawker centre selection by location
* Instant messaging between orderer and deliverer

**Use cases**
(The animated demo is done in emulator, hence it appears jerky)**:**

**Sign in**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/sign_in.gif" width="250" height="380" />
<br>
<br>

**Say you want to deliver food, this is how you would create an open order**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/create_open_order.gif" width="250" height="380" />
<br>
<br>

**On the other hand, if you want to order, this is how you would place one(ordering via the deliverer above)**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/place_order.gif" width="250" height="380" />
<br>
<br>

**On the deliverer's side, you would see the order placed by the orderer above. You then approve it by setting the prices**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/approve_order.gif" width="250" height="380" />
<br>
<br>

**Back to the orderer, once his order is approved, he can proceed to make the payment**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/authorize_payment.gif" width="250" height="380" />
<br>
<br>

**Deliver and orderer can now chat with one another!**

<img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/chat0.gif" width="250" height="380" /><img src="https://raw.githubusercontent.com/iamjackslayer/Media-for-Sambl/master/chat0.1.gif" width="250" height="380" />

