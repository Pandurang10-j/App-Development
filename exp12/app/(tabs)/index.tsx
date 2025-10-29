import { useRouter } from "expo-router";
import { signOut } from "firebase/auth";
import React from "react";
import { Alert, Image, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { auth } from "../../constants/firebaseConfig";

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
    backgroundColor: "#F6F9FF",
    justifyContent: "center",
    alignItems: "center",
    padding: 25,
  },
  heading: {
    fontSize: 28,
    fontWeight: "700",
    color: "#1E3A8A",
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
    color: "#475569",
    marginBottom: 25,
    lineHeight: 22,
  },
  logoutBtn: {
    backgroundColor: "#2563EB",
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 10,
    elevation: 3,
  },
  logoutText: {
    color: "white",
    fontSize: 16,
    fontWeight: "bold",
    letterSpacing: 0.5,
  },
});
