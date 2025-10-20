// index.tsx
import React, { useState, useEffect } from "react";
import { registerRootComponent } from "expo";
import { View, FlatList, StyleSheet, SafeAreaView, TextInput } from "react-native";
import { db } from "./firebaseConfig";
import {
  collection,
  addDoc,
  onSnapshot,
  deleteDoc,
  doc,
  updateDoc,
  query,
  where,
} from "firebase/firestore";
import { Text, Button, Card,  } from "react-native-paper";

interface Todo {
  id: string;
  title: string;
  completed: boolean;
}

function App() {
  const [todo, setTodo] = useState("");
  const [tasks, setTasks] = useState<Todo[]>([]);
  const [completedTasks, setCompletedTasks] = useState<Todo[]>([]);
  const [activeTab, setActiveTab] = useState<"Tasks" | "History">("Tasks");

  // Listen to Firestore updates
  useEffect(() => {
    const unsub = onSnapshot(collection(db, "todos"), (snapshot) => {
      const allTasks: Todo[] = [];
      snapshot.forEach((doc) =>
        allTasks.push({ id: doc.id, ...(doc.data() as any) })
      );
      setTasks(allTasks.filter((t) => !t.completed));
      setCompletedTasks(allTasks.filter((t) => t.completed));
    });
    return () => unsub();
  }, []);

  const addTodo = async () => {
    if (todo.trim() === "") return;
    await addDoc(collection(db, "todos"), { title: todo, completed: false });
    setTodo("");
  };

  const deleteTodo = async (id: string) => {
    await deleteDoc(doc(db, "todos", id));
  };

  const markCompleted = async (id: string) => {
    const taskRef = doc(db, "todos", id);
    await updateDoc(taskRef, { completed: true });
  };

  const renderItem = ({ item }: { item: Todo }) => (
    <Card style={styles.card}>
      <View style={styles.cardContent}>
        <Text style={styles.cardText}>{item.title}</Text>
        <View style={styles.buttons}>
          {!item.completed && (
            <Button mode="contained" onPress={() => markCompleted(item.id)}>
              ✅
            </Button>
          )}
          <Button mode="outlined" onPress={() => deleteTodo(item.id)}>
            🗑️
          </Button>
        </View>
      </View>
    </Card>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.header}>📝 To-Do App</Text>

      {/* Input Field */}
      {activeTab === "Tasks" && (
        <View style={styles.inputContainer}>
          <TextInput
            style={styles.input}
            placeholder="Add a new task..."
            value={todo}
            onChangeText={setTodo}
          />
          <Button mode="contained" onPress={addTodo} style={styles.addButton}>
            Add
          </Button>
        </View>
      )}

      {/* Tabs */}
      <View style={styles.tabContainer}>
        <Button
          mode={activeTab === "Tasks" ? "contained" : "text"}
          onPress={() => setActiveTab("Tasks")}
          style={styles.tabButton}
        >
          Tasks
        </Button>
        <Button
          mode={activeTab === "History" ? "contained" : "text"}
          onPress={() => setActiveTab("History")}
          style={styles.tabButton}
        >
          History
        </Button>
      </View>

      {/* Task List */}
      <FlatList
        data={activeTab === "Tasks" ? tasks : completedTasks}
        keyExtractor={(item) => item.id}
        renderItem={renderItem}
        style={{ marginTop: 10 }}
      />
    </SafeAreaView>
  );
}

// --- Styles ---
const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: "#f5f5f5" },
  header: { fontSize: 28, fontWeight: "bold", marginBottom: 20, textAlign: "center" },
  inputContainer: { flexDirection: "row", marginBottom: 10 },
  input: {
    flex: 1,
    backgroundColor: "#fff",
    borderRadius: 8,
    paddingHorizontal: 10,
    paddingVertical: 8,
    marginRight: 8,
    fontSize: 16,
  },
  addButton: { alignSelf: "center" },
  tabContainer: { flexDirection: "row", justifyContent: "space-around", marginVertical: 10 },
  tabButton: { flex: 1, marginHorizontal: 5 },
  card: { marginVertical: 5, borderRadius: 10, padding: 10, backgroundColor: "#fff", elevation: 2 },
  cardContent: { flexDirection: "row", justifyContent: "space-between", alignItems: "center" },
  cardText: { fontSize: 18 },
  buttons: { flexDirection: "row", gap: 10 },
});

registerRootComponent(App);
