import { useRouter } from "expo-router";
import { signOut } from "firebase/auth";
import React from "react";
import { Alert, Image, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { auth } from "../../constants/firebaseConfig";

// 🎨 You can change your color theme here
const COLORS = {
  background: "#F6F9FF",   // screen background
  heading: "#1E3A8A",      // heading text
  subText: "#475569",      // paragraph text
  button: "#2563EB",       // button background
  buttonText: "#FFFFFF",   // button text color
};

export default function HomeScreen() {
  const router = useRouter();

  const handleLogout = async () => {
    try {
      await signOut(auth);
      Alert.alert("Signed Out", "You have successfully logged out!");
      router.replace("/auth/login");
    } catch (error: any) {
      Alert.alert("Logout Error", error.message);
    }
  };

  return (
    <View style={styles.wrapper}>
      <Text style={styles.heading}>Welcome Back 👋</Text>

      <Image
        source={{
          uri: "https://cdn-icons-png.flaticon.com/512/5087/5087579.png",
        }}
        style={styles.avatar}
      />

      <Text style={styles.subText}>
        You are now signed in to your account.{"\n"}Manage your profile and explore more features below.
      </Text>

      <TouchableOpacity style={styles.logoutBtn} onPress={handleLogout}>
        <Text style={styles.logoutText}>Log Out</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    backgroundColor: COLORS.background, // 👈 change here
    justifyContent: "center",
    alignItems: "center",
    padding: 25,
  },
  heading: {
    fontSize: 28,
    fontWeight: "700",
    color: COLORS.heading, // 👈 change here
    marginBottom: 15,
  },
  avatar: {
    width: 120,
    height: 120,
    borderRadius: 60,
    marginBottom: 15,
  },
  subText: {
    textAlign: "center",
    fontSize: 15,
    color: COLORS.subText, // 👈 change here
    marginBottom: 25,
    lineHeight: 22,
  },
  logoutBtn: {
    backgroundColor: COLORS.button, // 👈 change here
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 10,
    elevation: 3,
  },
  logoutText: {
    color: COLORS.buttonText, // 👈 change here
    fontSize: 16,
    fontWeight: "bold",
    letterSpacing: 0.5,
  },
});
