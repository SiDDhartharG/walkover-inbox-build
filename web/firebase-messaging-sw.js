importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyDnIbtZBkaqAJLsrBuZcMXE7qSUHrWnXkA",
    authDomain: "kiss-16325.firebaseapp.com",
    databaseURL: "https://kiss-16325.firebaseio.com",
    projectId: "kiss-16325",
    storageBucket: "kiss-16325.appspot.com",
    messagingSenderId: "118321990441",
    appId: "1:118321990441:web:ea498d1f142241237d0538"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();
