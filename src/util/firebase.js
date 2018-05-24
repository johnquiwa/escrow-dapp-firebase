const firebase = require('firebase');
import config from '../../config.json';

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
