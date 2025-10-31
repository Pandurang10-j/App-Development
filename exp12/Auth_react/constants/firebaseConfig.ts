import { getApp, getApps, initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider, RecaptchaVerifier } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyBSHNyZOvToxga3GVsk6_Rf1jM9_ITH3Cg",
  authDomain: "authapp-e92de.firebaseapp.com",
  projectId: "authapp-e92de",
  storageBucket: "authapp-e92de.firebasestorage.app",
  messagingSenderId: "230477374233",
  appId: "1:230477374233:web:ca8d00311e378e719cdb88"
};

const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
const auth = getAuth(app);
const db = getFirestore(app);
const googleProvider = new GoogleAuthProvider();

export { app, auth, db, firebaseConfig, googleProvider, RecaptchaVerifier };

