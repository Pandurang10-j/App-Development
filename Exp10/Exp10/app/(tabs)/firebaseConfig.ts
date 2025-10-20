// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore"; // ✅ Add this line
import { getAnalytics } from "firebase/analytics";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBV-arsIIya7RJCZqk2_YcXscSrCxagYqE",
  authDomain: "todo-list-582e8.firebaseapp.com",
  projectId: "todo-list-582e8",
  storageBucket: "todo-list-582e8.firebasestorage.app",
  messagingSenderId: "106358155921",
  appId: "1:106358155921:web:56050842ed088a6ce5ed30",
  measurementId: "G-D3FME8ZWLD",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);



export const db = getFirestore(app); // ✅ Now works fine
