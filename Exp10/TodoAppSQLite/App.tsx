import React, { useState, useEffect } from "react";
import { SafeAreaView, FlatList, StyleSheet, TextInput, View } from "react-native";
import { Text, Button, Card } from "react-native-paper";
import SQLite from "expo-sqlite";


const db = (SQLite as any).openDatabase("todos.db");

interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

export default function App() {
  const [todo, setTodo] = useState("");
  const [tasks, setTasks] = useState<Todo[]>([]);
  const [completedTasks, setCompletedTasks] = useState<Todo[]>([]);
  const [activeTab, setActiveTab] = useState<"Tasks" | "History">("Tasks");

  // Create table on first load
  useEffect(() => {
    db.transaction(
      (tx: any) => {
        tx.executeSql(
          `CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            completed INTEGER NOT NULL
          );`
        );
      },
      (error: any) => console.log("Error creating table:", error),
      () => loadTasks()
    );
  }, []);

  // Load tasks from SQLite
  const loadTasks = () => {
    db.transaction((tx: any) => {
      tx.executeSql(
        "SELECT * FROM todos",
        [],
        (_: any, { rows }: any) => {
          const all: Todo[] = [];
          for (let i = 0; i < rows.length; i++) {
            const item = rows.item(i);
            all.push({
              id: item.id,
              title: item.title,
              completed: item.completed === 1,
            });
          }
          setTasks(all.filter((t) => !t.completed));
          setCompletedTasks(all.filter((t) => t.completed));
        },
        (_: any, error: any) => {
          console.log("Error loading tasks:", error);
          return false;
        }
      );
    });
  };

  const addTodo = () => {
    if (todo.trim() === "") return;
    db.transaction(
      (tx: any) => {
        tx.executeSql("INSERT INTO todos (title, completed) VALUES (?, ?)", [todo, 0]);
      },
      (error: any) => console.log("Error adding todo:", error),
      () => loadTasks()
    );
    setTodo("");
  };

  const deleteTodo = (id: number) => {
    db.transaction(
      (tx: any) => {
        tx.executeSql("DELETE FROM todos WHERE id = ?", [id]);
      },
      (error: any) => console.log("Error deleting todo:", error),
      () => loadTasks()
    );
  };

  const markCompleted = (id: number) => {
    db.transaction(
      (tx: any) => {
        tx.executeSql("UPDATE todos SET completed = 1 WHERE id = ?", [id]);
      },
      (error: any) => console.log("Error marking completed:", error),
      () => loadTasks()
    );
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
      <Text style={styles.header}>📝 To-Do App (SQLite)</Text>

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

      <FlatList
        data={activeTab === "Tasks" ? tasks : completedTasks}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderItem}
        style={{ marginTop: 10 }}
      />
    </SafeAreaView>
  );
}

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
