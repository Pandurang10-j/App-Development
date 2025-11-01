// app/(tabs)/explore.tsx
import React from "react";
import { StyleSheet, Text, View } from "react-native";

// 🎨 Define your color theme here
const COLORS = {
  background: "#FFFFFF", // screen background color
  text: "#1E3A8A",       // text color
};

export default function Explore() {
  return (
    <View style={styles.wrapper}>
      <Text style={styles.text}>Explore</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: COLORS.background, // 👈 change here
  },
  text: {
    fontSize: 22,
    fontWeight: "600",
    color: COLORS.text, // 👈 change here
  },
});
