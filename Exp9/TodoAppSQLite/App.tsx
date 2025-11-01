import React, { useEffect, useState } from "react";
import { View, Text, TextInput, TouchableOpacity, FlatList, StyleSheet, Alert } from "react-native";
import * as SQLite from "expo-sqlite";

interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

export default function App() {
  const [db, setDb] = useState<SQLite.SQLiteDatabase | null>(null);
  const [task, setTask] = useState("");
  const [tasks, setTasks] = useState<Todo[]>([]);
  const [completedTasks, setCompletedTasks] = useState<Todo[]>([]);

  useEffect(() => {
    const openDB = async () => {
      try {
        const database = await SQLite.openDatabaseAsync("todo.db");
        setDb(database);
        await database.execAsync(`
          CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            completed INTEGER DEFAULT 0
          );
        `);
        loadTasks(database);
      } catch (error) {
        console.error("Database open error:", error);
      }
    };
    openDB();
  }, []);

  const loadTasks = async (database: SQLite.SQLiteDatabase) => {
    try {
      const rows = await database.getAllAsync<{ id: number; title: string; completed: number }>(
        "SELECT * FROM todos"
      );
      const all: Todo[] = rows.map((item) => ({
        id: item.id,
        title: item.title,
        completed: item.completed === 1,
      }));
      setTasks(all.filter((t) => !t.completed));
      setCompletedTasks(all.filter((t) => t.completed));
    } catch (error) {
      console.error("Load error:", error);
    }
  };

  const addTask = async () => {
    if (!task.trim() || !db) return Alert.alert("Please enter a task");
    try {
      await db.runAsync("INSERT INTO todos (title, completed) VALUES (?, ?)", [task, 0]);
      setTask("");
      loadTasks(db);
    } catch (error) {
      console.error("Add error:", error);
    }
  };

  const toggleComplete = async (id: number, completed: boolean) => {
    if (!db) return;
    try {
      await db.runAsync("UPDATE todos SET completed = ? WHERE id = ?", [completed ? 0 : 1, id]);
      loadTasks(db);
    } catch (error) {
      console.error("Toggle error:", error);
    }
  };

  const deleteTask = async (id: number) => {
    if (!db) return;
    try {
      await db.runAsync("DELETE FROM todos WHERE id = ?", [id]);
      loadTasks(db);
    } catch (error) {
      console.error("Delete error:", error);
    }
  };

  const renderTask = ({ item }: { item: Todo }) => (
    <View style={styles.task}>
      <Text style={[styles.taskText, item.completed && styles.completedText]}>{item.title}</Text>
      <View style={styles.buttons}>
        <TouchableOpacity onPress={() => toggleComplete(item.id, item.completed)}>
          <Text style={styles.completeBtn}>{item.completed ? "Undo" : "Done"}</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => deleteTask(item.id)}>
          <Text style={styles.deleteBtn}>Delete</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>SQLite ToDo App</Text>

      <View style={styles.inputContainer}>
        <TextInput
          value={task}
          onChangeText={setTask}
          placeholder="Enter a task..."
          style={styles.input}
        />
        <TouchableOpacity onPress={addTask} style={styles.addButton}>
          <Text style={styles.addText}>Add</Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.sectionTitle}>Pending Tasks</Text>
      <FlatList data={tasks} keyExtractor={(item) => item.id.toString()} renderItem={renderTask} />

      <Text style={styles.sectionTitle}>Completed Tasks</Text>
      <FlatList
        data={completedTasks}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderTask}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f8f9fa",
    paddingTop: 50,
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: "bold",
    color: "#222",
    textAlign: "center",
    marginBottom: 20,
  },
  inputContainer: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 20,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: "#aaa",
    borderRadius: 10,
    padding: 10,
    fontSize: 16,
  },
  addButton: {
    backgroundColor: "#007bff",
    marginLeft: 10,
    padding: 12,
    borderRadius: 10,
  },
  addText: {
    color: "#fff",
    fontWeight: "bold",
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: "bold",
    marginTop: 20,
    marginBottom: 10,
  },
  task: {
    flexDirection: "row",
    justifyContent: "space-between",
    backgroundColor: "#fff",
    padding: 12,
    borderRadius: 10,
    marginVertical: 5,
    shadowColor: "#000",
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: 2 },
    elevation: 2,
  },
  taskText: {
    fontSize: 16,
    color: "#333",
  },
  completedText: {
    textDecorationLine: "line-through",
    color: "#888",
  },
  buttons: {
    flexDirection: "row",
    gap: 10,
  },
  completeBtn: {
    color: "green",
    marginRight: 10,
  },
  deleteBtn: {
    color: "red",
  },
});
