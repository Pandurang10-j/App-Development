import { Ionicons } from "@expo/vector-icons";
import { useRouter } from "expo-router";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithEmailAndPassword,
  signInWithPopup,
} from "firebase/auth";
import React, { useState } from "react";
import {
  Alert,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { app } from "../../constants/firebaseConfig";

const auth = getAuth(app);

export default function LoginScreen() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
      router.replace("/profile");
    } catch (err: any) {
      Alert.alert("Login Failed", err.message);
    }
  };

  const handleGoogleLogin = async () => {
    try {
      const provider = new GoogleAuthProvider();
      await signInWithPopup(auth, provider);
      router.replace("/profile");
    } catch (err: any) {
      Alert.alert("Google Login Failed", err.message);
    }
  };

  const handlePhoneLogin = () => {
    router.push("/auth/phone");
  };

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Hey there 👋</Text>
      <Text style={styles.title}>Log in to Continue</Text>

      <TextInput
        style={styles.input}
        placeholder="Enter your email"
        placeholderTextColor="#9CA3AF"
        keyboardType="email-address"
        onChangeText={setEmail}
        value={email}
      />

      <View style={styles.passwordContainer}>
        <TextInput
          style={[styles.input, { flex: 1, marginVertical: 0, borderWidth: 0 }]}
          placeholder="Enter your password"
          placeholderTextColor="#9CA3AF"
          secureTextEntry={!showPassword}
          onChangeText={setPassword}
          value={password}
        />
        <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
          <Ionicons
            name={showPassword ? "eye-off" : "eye"}
            size={22}
            color="#6B7280"
          />
        </TouchableOpacity>
      </View>

      <TouchableOpacity
        onPress={() =>
          Alert.alert(
            "Forgot Password?",
            "Password reset link feature coming soon!"
          )
        }
      >
        <Text style={styles.forgot}>Forgot Password?</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.loginBtn} onPress={handleLogin}>
        <Text style={styles.loginText}>Sign In</Text>
      </TouchableOpacity>

      <Text style={styles.or}>─── Continue with ───</Text>

      <TouchableOpacity style={styles.googleBtn} onPress={handleGoogleLogin}>
        <Ionicons name="logo-google" size={20} color="white" />
        <Text style={styles.socialText}>Google</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.phoneBtn} onPress={handlePhoneLogin}>
        <Ionicons name="call" size={20} color="white" />
        <Text style={styles.socialText}>Phone</Text>
      </TouchableOpacity>

      <View style={styles.signupContainer}>
        <Text style={styles.signupText}>New user? </Text>
        <TouchableOpacity onPress={() => router.push("/auth/signup")}>
          <Text style={styles.signupLink}>Create Account</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#EEF2FF", // soft bluish background
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 28,
  },
  welcome: {
    fontSize: 20,
    color: "#3B82F6",
    fontWeight: "600",
    marginBottom: 4,
  },
  title: {
    fontSize: 28,
    fontWeight: "700",
    color: "#1E3A8A",
    marginBottom: 25,
  },
  input: {
    width: "100%",
    backgroundColor: "white",
    padding: 14,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#E5E7EB",
    marginVertical: 10,
    fontSize: 16,
  },
  passwordContainer: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#E5E7EB",
    borderRadius: 12,
    paddingHorizontal: 10,
    width: "100%",
    marginBottom: 8,
  },
  forgot: {
    alignSelf: "flex-end",
    color: "#3B82F6",
    fontSize: 14,
    marginBottom: 20,
  },
  loginBtn: {
    backgroundColor: "#3B82F6",
    width: "100%",
    padding: 15,
    borderRadius: 12,
    alignItems: "center",
    marginBottom: 20,
    elevation: 3,
  },
  loginText: {
    color: "white",
    fontSize: 17,
    fontWeight: "600",
  },
  or: {
    color: "#6B7280",
    fontSize: 14,
    marginBottom: 15,
  },
  googleBtn: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#DB4437",
    width: "100%",
    padding: 14,
    borderRadius: 12,
    marginBottom: 10,
    elevation: 2,
  },
  phoneBtn: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#16A34A",
    width: "100%",
    padding: 14,
    borderRadius: 12,
    marginBottom: 25,
    elevation: 2,
  },
  socialText: {
    color: "white",
    fontWeight: "600",
    fontSize: 16,
    marginLeft: 8,
  },
  signupContainer: {
    flexDirection: "row",
    alignItems: "center",
  },
  signupText: {
    color: "#475569",
    fontSize: 15,
  },
  signupLink: {
    color: "#2563EB",
    fontWeight: "700",
    fontSize: 15,
  },
});
