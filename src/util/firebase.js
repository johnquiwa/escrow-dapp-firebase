const firebase = require('firebase')

// Initialize Firebase
const config = {
  apiKey: "AIzaSyD6ypc-tdzvmoNaHKz4rxoZwx5nTMAesAg",
  authDomain: "escrow-eth.firebaseapp.com",
  databaseURL: "https://escrow-eth.firebaseio.com",
  projectId: "escrow-eth",
  storageBucket: "escrow-eth.appspot.com",
  messagingSenderId: "251713990636"
};

firebase.initializeApp(config);

const removeKey = firePath =>
  firebase.database().ref(firePath).remove()

const createRef = firePath =>
  firebase.database().ref(firePath)

const removeRef = firePath =>
  firebase.database().ref(firePath).off()

const updateOrder = (firePath, newDataObj) => {
  Object.entries(newDataObj).forEach(([key, prop]) =>
    firebase.database().ref(`${firePath}/${key}`).set(prop)
  )
}

module.exports =  {
  removeKey,
  removeRef,
  createRef,
  updateOrder,
}
