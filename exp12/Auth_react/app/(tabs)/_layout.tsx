// app/(tabs)/_layout.tsx
import { MaterialIcons } from "@expo/vector-icons";
import { Tabs } from "expo-router";
import React from "react";

// 🎨 Define your color theme here
const COLORS = {
  tabBarBackground: "#FFFFFF", // Tab bar background
  tabActive: "#2563EB",        // Active icon/text color
  tabInactive: "#94A3B8",      // Inactive icon/text color
  headerBackground: "#F6F9FF", // Header background
  headerText: "#1E3A8A",       // Header title color
};

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: true,
        headerStyle: { backgroundColor: COLORS.headerBackground },
        headerTitleStyle: { color: COLORS.headerText },
        tabBarStyle: {
          backgroundColor: COLORS.tabBarBackground,
          borderTopWidth: 0.3,
          borderTopColor: "#E2E8F0",
          height: 60,
        },
        tabBarActiveTintColor: COLORS.tabActive,
        tabBarInactiveTintColor: COLORS.tabInactive,
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: "Home",
          tabBarIcon: ({ color, size }) => (
            <MaterialIcons name="home" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: "Explore",
          tabBarIcon: ({ color, size }) => (
            <MaterialIcons name="search" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: "Profile",
          tabBarIcon: ({ color, size }) => (
            <MaterialIcons name="person" size={size} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}
